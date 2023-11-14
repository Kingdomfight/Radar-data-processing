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

function testDetectedActive(testCase)
	startX = 1;
	startY = 2;
	vX = 3;
	vY = 4;
	dt = 0.5;
	[actOutput{1}{1:5}] = testCase.TestData.dut(0, startX, startY, true);
	newX = startX+vX*dt;
	newY = startY+vY*dt;
	[actOutput{2}{1:5}] = testCase.TestData.dut(dt, newX, newY, true);
	expOutput{1} = {startX, startY, 0, 0, true};
	expOutput{2} = {newX, newY, vX, vY, true};
	verifyEqual(testCase, actOutput, expOutput)
end