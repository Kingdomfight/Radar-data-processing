function tests = zoneCheckTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = zoneCheck();
end

function testObstacleInZone(testCase)
	input = struct('px', 0, 'py', 0, 'vx', 0, 'vy', 0, 'tracking', true);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, true);
end

function testObstacleOnBorder(testCase)
	input = struct('px', testCase.TestData.dut.RADIUS, 'py', 0, 'vx', 0, 'vy', 0, 'tracking', true);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, true);
end

function testObstacleMovingDiagonallyIntoZone(testCase)
	px = -testCase.TestData.dut.RADIUS;
	py = -testCase.TestData.dut.RADIUS;
	vx = -px/testCase.TestData.dut.TIME_THRESHOLD;
	vy = -py/testCase.TestData.dut.TIME_THRESHOLD;
	input = struct('px', px, 'py', py, 'vx', vx, 'vy', vy, 'tracking', true);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, true);
end

function testObstacleMovingVerticallyIntoZone(testCase)
	px = 0;
	py = -testCase.TestData.dut.RADIUS;
	vx = 0;
	vy = -py/testCase.TestData.dut.TIME_THRESHOLD;
	input = struct('px', px, 'py', py, 'vx', vx, 'vy', vy, 'tracking', true);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, true);
end

function testObstacleMovingInAndOutZone(testCase)
	px = -testCase.TestData.dut.RADIUS;
	py = -testCase.TestData.dut.RADIUS;
	vx = -px/testCase.TestData.dut.TIME_THRESHOLD*10;
	vy = -py/testCase.TestData.dut.TIME_THRESHOLD*10;
	input = struct('px', px, 'py', py, 'vx', vx, 'vy', vy, 'tracking', true);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, true);
end

function testObstacleMovingOutsideZone(testCase)
	px = -testCase.TestData.dut.RADIUS;
	py = -testCase.TestData.dut.RADIUS;
	vx = px/testCase.TestData.dut.TIME_THRESHOLD;
	vy = py/testCase.TestData.dut.TIME_THRESHOLD;
	input = struct('px', px, 'py', py, 'vx', vx, 'vy', vy, 'tracking', true);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, false);
end