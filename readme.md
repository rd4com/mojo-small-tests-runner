# 🥼 🐒 mojo small tests runner
> licensed under the Apache License v2.0 with LLVM Exceptions

Only 100 LOC, in order to minimise chances of bugs 🖖.

If you see a security issue, please submit a PR, otherwise  please don't.

Feel free to use, fork, modify, customize and be happy!

It is just using some variadic parameters, 

feel free to re-imagine the concept and create a lib in your own way!





 










&nbsp;

A test-function have to have that form:
```mojo
alias TEST_FUNCTION_T = fn() -> TestResult
```
It should return a TestResult:
```mojo
alias TestResult = Variant[TestFail,TestSuccess]
```
- ```mojo
    return TestFail("Some message")
  ```
- ```mojo
    return TestSuccess()
  ```

## Example

```mojo
from testing import *
from small_tests_runner import *

fn BasicTests() -> TestResult:
    try:
        with assert_raises():
            raise "Error"
            #_ = 1 # not raise
    except e:
        return TestFail(str(e))

    var a = "ok"
    if a != "ok": return TestFail("a!='ok'")
    
    try: 
        Dict[Int,Int]()[0]
        return TestFail("should have raised")
    except e: ...

    try:
        assert_equal(1,2,"1 == 2")
    except e: 
        return TestFail(str(e))
    
    return TestSuccess()

fn MoreTests() -> TestResult:
    try:
        assert_equal(1,1,"1 == 1")
    except e: 
        return TestFail(str(e))

    return TestSuccess()

fn main():
    var t = TestRunner[
        ("Basic tests", BasicTests),
        ("More tests", MoreTests),
        stop_testing_if_one_test_fails = False
    ]()
    t.run()
```

### output

```
Basic tests
Test fail
         At /tmp/main.mojo:21:21: AssertionError: `left == right` comparison failed:
   left: 1
  right: 2
  reason: 1 == 2
         /tmp/main.mojo
         23
More tests
Test finished

Performed:       2 / 2
Failed:          1 / 2
Succeeded:       1 / 2

The stop_testing_if_one_test_fails parameter is set to False
It means that test 2 will be performed even if test 1 fails
At least one test failed
```

## Example 2
It is possible to run only one test by providing a "test name":
```mojo
...
...
from sys.param_env import env_get_string
t.run_only_this_test[
    env_get_string["test_name"]()
]()
```
```mojo -D test_name="Basic tests" main.mojo```