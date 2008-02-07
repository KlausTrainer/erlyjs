// Required. Return here a description of the test case.
function test_description() {
    return "Greater '>' operator test";
}

// Required. Return here an array of arguments the testsuite will use 
// to invoke the test() function. For no arguments return an empty array.
function test_args() {
    return [];
}

// Required. Return here the expected test result.
function test_result() {
    return true;
}

// Optional. Provide here any global code.


// Required. The actual test. 
// Testsuite invokes this function with the arguments from test_args()
// and compares the return value with the expected result from test_result().
function test() {
    var a=4, b=2, c;
    c = a > b;
    return c;
}