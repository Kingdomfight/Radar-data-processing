function tests = obstacleTrackerTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = obstacleTracker();
end

function testNotDetectNotActive(testCase)
	[actOutput{1:5}] = testCase.TestData.dut(0, 0, 0, false);
	expOutput = {0, 0, 0, 0, false};
	verifyEqual(testCase, actOutput, expOutput)
end

function testDetectedNotActive(testCase)
	[actOutput{1:5}] = testCase.TestData.dut(0, 1, 2, true);
	expOutput = {1, 2, 0, 0, true};
	verifyEqual(testCase, actOutput, expOutput)
end