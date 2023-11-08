function tests = polarToCartTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = polarToCart();
end

function testQuadrant1(testCase)
	[actOut(1), actOut(2)] = testCase.TestData.dut(45, 1);
	expOut = [sqrt(2)/2 sqrt(2)/2];
	verifyEqual(testCase, actOut, expOut);
end

function testQuadrant2(testCase)
	[actOut(1), actOut(2)] = testCase.TestData.dut(135, 1);
	expOut = [-sqrt(2)/2 sqrt(2)/2];
	verifyEqual(testCase, actOut, expOut);
end

function testQuadrant3(testCase)
	[actOut(1), actOut(2)] = testCase.TestData.dut(225, 1);
	expOut = [-sqrt(2)/2 -sqrt(2)/2];
	verifyEqual(testCase, actOut, expOut);
end

function testQuadrant4(testCase)
	[actOut(1), actOut(2)] = testCase.TestData.dut(315, 1);
	expOut = [sqrt(2)/2 -sqrt(2)/2];
	verifyEqual(testCase, actOut, expOut);
end