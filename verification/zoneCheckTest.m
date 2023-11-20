function tests = zoneCheckTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = zoneCheck();
end

function testMovingObstacleInZone(testCase)
	input = struct('px', 0, 'py', 0, 'vx', 1, 'vy', 3, 'tracking', 1);
	actOut = testCase.TestData.dut(input);
	expOut = true;
	verifyEqual(testCase, actOut, expOut);
end