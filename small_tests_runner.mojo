from builtin._location import __call_location
from utils.variant import Variant

@value
struct TestFail:
    var loc_file: String
    var loc_line: String
    var name:String

    @always_inline
    fn __init__(inout self, name:String):
        var loc = __call_location()
        self.loc_file = loc.file_name
        self.loc_line = loc.line
        self.name = name

alias TestSuccess = String
alias TestResult = Variant[TestFail,TestSuccess]
alias TEST_FUNCTION_T = fn() -> TestResult

struct TestRunner[
    *Tests: Tuple[
        StringLiteral,
        TEST_FUNCTION_T
    ],
    stop_testing_if_one_test_fails:Bool
]:
    fn __init__(
        inout self
    ): ...

    @staticmethod
    fn run():
        var stop=False
        var done = 0
        var failed = 0
        var succeeded = 0
        @parameter
        fn SingleTest[Index:Int]():
            if stop: return
            print(Tests[Index].get[0,StringLiteral]())
            alias f = Tests[Index].get[1,TEST_FUNCTION_T]()
            var res= f()
            if res.isa[TestFail]():
                @parameter
                if stop_testing_if_one_test_fails:
                    stop = True
                failed+=1
                print("Test fail")
                print("\t",res[TestFail].name)
                print("\t",res[TestFail].loc_file)
                print("\t",res[TestFail].loc_line)
            if res.isa[TestSuccess]():
                succeeded+=1
                print("Test finished")
            done+=1

        unroll[SingleTest,len(VariadicList(Tests))]()
        print("")
        print("Performed:\t",done,"/",len(VariadicList(Tests)))
        print("Failed:\t\t",failed,"/",len(VariadicList(Tests)))
        print("Succeeded:\t",succeeded,"/",len(VariadicList(Tests)))
        print("")
        if stop:
            print("Testing aborted!")
            print("Not all tests have been performed.")
            print("The stop_testing_if_one_test_fails parameter is set to True")
        else:
            print("The stop_testing_if_one_test_fails parameter is set to False")
            print("It means that test 2 will be performed even if test 1 fails")

        if stop == False and done == len(VariadicList(Tests)) 
            and succeeded == len(VariadicList(Tests)) and failed == 0:
            print("All tests succeeded, no tests have failed")
        if failed != 0:
            print("At least one test failed")

    @staticmethod
    fn run_only_this_test[test_name:StringLiteral]():
        var found = False
        @parameter
        fn SingleTest[Index:Int]():
            @parameter
            if test_name == Tests[Index].get[0,StringLiteral]():  
                found = True        
                print(Tests[Index].get[0,StringLiteral]())
                alias f = Tests[Index].get[1,TEST_FUNCTION_T]()
                var res= f()
                if res.isa[TestFail]():
                    print("Test fail")
                    print("\t",res[TestFail].name)
                    print("\t",res[TestFail].loc_file)
                    print("\t",res[TestFail].loc_line)
                if res.isa[TestSuccess]():
                    print("Test finished")
        unroll[SingleTest,len(VariadicList(Tests))]()
        if found == False: 
            print("No test have been performed")
            print("Test not found:",test_name)