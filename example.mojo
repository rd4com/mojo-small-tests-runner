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

from sys.param_env import env_get_string
fn main():
    var t = TestRunner[
        ("Basic tests", BasicTests),
        ("More tests", MoreTests),
        stop_testing_if_one_test_fails = False
    ]()
    t.run()

    #t.run_only_this_test[env_get_string["test_name"]()]()
    #mojo -D test_name="Basic tests" main.mojo

