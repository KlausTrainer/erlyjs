// Mandatory. Return here a description of the test case.
function test_description() {
    return "Bitwise shift left '<<' operator test";
}

// Mandatory. Return here an array of arguments the testsuite will use 
// to invoke the test() function. For no arguments return an empty array.
function test_args() {
    return [];
}

// Mandatory. Return here the expected test result.
function test_assert() {
    return 16;
}

// Optional. Provide here any global code.


// Mandatory. The actual test. 
// Testsuite invokes this function with the arguments from test_args()
// and compares the return value with the expected result from test_assert().
function test() {
    var a=4, b=2, c;
    c = a << b;
    return c;
}