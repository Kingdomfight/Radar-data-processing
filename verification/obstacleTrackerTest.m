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
	dt = 0.5;
	vX(1:2) = [3 -2];
	vY(1:2) = [4 -6];
	x(1) = 1; y(1) = 2;

	x(2) = x(1)+vX(1)*dt;
	y(2) = y(1)+vY(1)*dt;
	x(3) = x(2)+vX(2)*dt;
	y(3) = y(2)+vY(2)*dt;

	[actOutput{1}{1:5}] = testCase.TestData.dut(0, x(1), y(1), true);
	[actOutput{2}{1:5}] = testCase.TestData.dut(dt, x(2), y(2), true);
	[actOutput{3}{1:5}] = testCase.TestData.dut(dt*2, x(3), y(3), true);

	expOutput{1} = {x(1), y(1), 0, 0, true};
	expOutput{2} = {x(2), y(2), vX(1), vY(1), true};
	expOutput{3} = {x(3), y(3), vX(2), vY(2), true};
	verifyEqual(testCase, actOutput, expOutput)
end

function testNotDetectedActive(testCase)
	dt = 0.25;
	vX = -7;
	vY = 4;
	x(1) = -3; y(1) = -2;

	x(2) = x(1)+vX*dt;
	y(2) = y(1)+vY*dt;
	x(3) = x(2)+vX*dt;
	y(3) = y(2)+vY*dt;

	[actOutput{1}{1:5}] = testCase.TestData.dut(0, x(1), y(1), true);
	[actOutput{2}{1:5}] = testCase.TestData.dut(dt, x(2), y(2), true);
	[actOutput{3}{1:5}] = testCase.TestData.dut(dt*2, 0, 0, false);

	expOutput{1} = {x(1), y(1), 0, 0, true};
	expOutput{2} = {x(2), y(2), vX, vY, true};
	expOutput{3} = {x(3), y(3), vX, vY, true};
	verifyEqual(testCase, actOutput, expOutput)
end