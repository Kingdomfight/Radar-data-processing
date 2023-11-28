function tests = zoneCheckTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = zoneCheck();
end

function testObstacleStationaryInsideZone(testCase)
	px = 0;
	py = 0;
	vx = 0;
	vy = 0;
	input = struct('px', px, 'py', py, 'vx', vx, 'vy', vy, 'tracking', true);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, true);
end

function testUntrackedObstacleInsideZone(testCase)
	px = 0;
	py = 0;
	vx = 0;
	vy = 0;
	input = struct('px', px, 'py', py, 'vx', vx, 'vy', vy, 'tracking', false);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, false);
end

function testObstacleStationaryOnBorder(testCase)
	px = testCase.TestData.dut.RADIUS;
	py = 0;
	vx = 0;
	vy = 0;
	input = struct('px', px, 'py', py, 'vx', vx, 'vy', vy, 'tracking', true);
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

function testObstacleStationaryOutsideZone(testCase)
	px = testCase.TestData.dut.RADIUS*2;
	py = testCase.TestData.dut.RADIUS*2;
	vx = 0;
	vy = 0;
	input = struct('px', px, 'py', py, 'vx', vx, 'vy', vy, 'tracking', true);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, false);
end

function testMultipleInputsInZone(testCase)
	px(1) = testCase.TestData.dut.RADIUS*2;
	py(1) = testCase.TestData.dut.RADIUS*2;
	px(2) = 0;
	py(2) = 0;
	vx = 0;
	vy = 0;
	singleInput(1) = struct('px', px(1), 'py', py(1), 'vx', vx, 'vy', vy, 'tracking', true);
	singleInput(2) = struct('px', px(2), 'py', py(2), 'vx', vx, 'vy', vy, 'tracking', true);
	input(1:7) = repmat(singleInput(1), 1, 7);
	input(8) = singleInput(2);
	actOut = testCase.TestData.dut(input);
	verifyEqual(testCase, actOut, true);
end