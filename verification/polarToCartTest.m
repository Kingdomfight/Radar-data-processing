function tests = polarToCartTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = polarToCart();
end

function testQuadrant1(testCase)
	actOut = testCase.TestData.dut(45, 1);
	expOut = struct('px', sqrt(2)/2, 'py', sqrt(2)/2);
	verifyEqual(testCase, actOut, expOut);
end

function testQuadrant2(testCase)
	actOut = testCase.TestData.dut(135, 1);
	expOut = struct('px', -sqrt(2)/2, 'py', sqrt(2)/2);
	verifyEqual(testCase, actOut, expOut);
end

function testQuadrant3(testCase)
	actOut = testCase.TestData.dut(225, 1);
	expOut = struct('px', -sqrt(2)/2, 'py', -sqrt(2)/2);
	verifyEqual(testCase, actOut, expOut);
end

function testQuadrant4(testCase)
	actOut = testCase.TestData.dut(315, 1);
	expOut = struct('px', sqrt(2)/2, 'py', -sqrt(2)/2);
	verifyEqual(testCase, actOut, expOut);
end

function testDistance(testCase)
	distance = 8.756; % random
	actOut = testCase.TestData.dut(0, distance);
	expOut = struct('px', distance, 'py', 0);
	verifyEqual(testCase, actOut, expOut);
end

% Test first too small angle
function testAngle2Small(testCase)
	verifyError(testCase, @() testCase.TestData.dut(-eps, 1), 'polarToCart:InputOutOfRange')
end

% Test first too large angle
function testAngle2Large(testCase)
	verifyError(testCase, @() testCase.TestData.dut(360, 1), 'polarToCart:InputOutOfRange')
end

% Test first negative distance
function testDistanceNegative(testCase)
	verifyError(testCase, @() testCase.TestData.dut(45, -eps), 'polarToCart:InputOutOfRange')
end