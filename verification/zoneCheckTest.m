function tests = zoneCheckTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = zoneCheck();
end

function testObstacleInZone(testCase)
	input = struct('px', 0, 'py', 0, 'vx', 0, 'vy', 0, 'tracking', 1);
	actOut = testCase.TestData.dut(input);
	expOut = true;
	verifyEqual(testCase, actOut, expOut);
end

function testObstacleOnBorder(testCase)
	input = struct('px', 5, 'py', 0, 'vx', 0, 'vy', 0, 'tracking', 1);
	actOut = testCase.TestData.dut(input);
	expOut = true;
	verifyEqual(testCase, actOut, expOut);
end