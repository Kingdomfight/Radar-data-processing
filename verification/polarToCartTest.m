function tests = polarToCartTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = polarToCart();
end

function testQuadrant1(testCase)
	actOut = testCase.TestData.dut(45, 1);
	expOut = struct('px', sqrt(2)/2, 'py', sqrt(2)/2);
	errPx = abs(actOut.px-expOut.px);
	errPy = abs(actOut.py-expOut.py);
	verifyLessThan(testCase, errPx, eps(single(1)));
	verifyLessThan(testCase, errPy, eps(single(1)));
end

function testQuadrant2(testCase)
	actOut = testCase.TestData.dut(135, 1);
	expOut = struct('px', -sqrt(2)/2, 'py', sqrt(2)/2);
	errPx = abs(actOut.px-expOut.px);
	errPy = abs(actOut.py-expOut.py);
	verifyLessThan(testCase, errPx, eps(single(1)));
	verifyLessThan(testCase, errPy, eps(single(1)));
end

function testQuadrant3(testCase)
	actOut = testCase.TestData.dut(225, 1);
	expOut = struct('px', -sqrt(2)/2, 'py', -sqrt(2)/2);
	errPx = abs(actOut.px-expOut.px);
	errPy = abs(actOut.py-expOut.py);
	verifyLessThan(testCase, errPx, eps(single(1)));
	verifyLessThan(testCase, errPy, eps(single(1)));
end

function testQuadrant4(testCase)
	actOut = testCase.TestData.dut(315, 1);
	expOut = struct('px', sqrt(2)/2, 'py', -sqrt(2)/2);
	errPx = abs(actOut.px-expOut.px);
	errPy = abs(actOut.py-expOut.py);
	verifyLessThan(testCase, errPx, eps(single(1)));
	verifyLessThan(testCase, errPy, eps(single(1)));
end

function testDistance(testCase)
	distance = 8.756; % random
	actOut = testCase.TestData.dut(0, distance);
	expOut = struct('px', distance, 'py', 0);
	errPx = abs(actOut.px-expOut.px);
	errPy = abs(actOut.py-expOut.py);
	verifyLessThan(testCase, errPx, eps(single(1)));
	verifyLessThan(testCase, errPy, eps(single(1)));
end