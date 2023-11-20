function tests = obstacleWrapperTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = obstacleWrapper();
end

function testInputTypeChecking(testCase)
	detectPos = struct('px', 0, 'py', 0);
	functionHandle = @() testCase.TestData.dut(4, detectPos, 0);
	verifyError(testCase, functionHandle, 'obstacleWrapper:IncorrectInputType');
end

function testInputValueChecking(testCase)
	detectIdx = uint8(5);
	detectPos = struct('px', 0, 'py', 0);
	functionHandle = @() testCase.TestData.dut(detectIdx, detectPos, 0);
	verifyError(testCase, functionHandle, 'obstacleWrapper:IncorrectInputValue');
end

function testObstacleSelection(testCase)
	% Input
	detectIdx = [1 4 8 8];
	detectPos(1) = struct('px', 0, 'py', 1);
	detectPos(2) = struct('px', 2, 'py', 3);
	detectPos(3) = struct('px', 4, 'py', 5);
	detectPos(4) = struct('px', 10, 'py', 11);
	time = [0 0 0 10];

	% Actual output
	detectEncode = uint8(2.^(detectIdx-1));
	actOut(1,:) = testCase.TestData.dut(detectEncode(1), detectPos(1), time(1));
	actOut(2,:) = testCase.TestData.dut(detectEncode(2), detectPos(2), time(2));
	actOut(3,:) = testCase.TestData.dut(detectEncode(3), detectPos(3), time(3));
	actOut(4,:) = testCase.TestData.dut(detectEncode(4), detectPos(4), time(4));

	% Expected output
	tracker = obstacleTracker;
	[trackerRaw{1, 1:5}] = tracker(0, 0, 0, 0);
	[trackerRaw{2, 1:5}] = tracker(time(1), detectPos(1).px, detectPos(1).py, 1);
	tracker.reset();
	[trackerRaw{3, 1:5}] = tracker(time(2), detectPos(2).px, detectPos(2).py, 1);
	tracker.reset();
	[trackerRaw{4, 1:5}] = tracker(time(3), detectPos(3).px, detectPos(3).py, 1);
	[trackerRaw{5, 1:5}] = tracker(time(4), detectPos(4).px, detectPos(4).py, 1);

	% Format from cell arrays to structs
	for i=5:-1:1
		trackerStruct(i) = struct('px', trackerRaw{i, 1}, 'py', trackerRaw{i, 2}, ...
			'vx', trackerRaw{i, 3},'vy', trackerRaw{i, 4}, ...
			'tracking', trackerRaw{i, 5});
	end

	% Format like DUT output
	expOut(1,:) = repmat(trackerStruct(1), 1, testCase.TestData.dut.NUM_OBSTACLE_TRACKER);
	expOut(1, detectIdx(1)) = trackerStruct(2);
	expOut(2,:) = expOut(1, :);
	expOut(2, detectIdx(2)) = trackerStruct(3);
	expOut(3,:) = expOut(2, :);
	expOut(3, detectIdx(3)) = trackerStruct(4);
	expOut(4,:) = expOut(3, :);
	expOut(4, detectIdx(4)) = trackerStruct(5);

	verifyEqual(testCase, actOut(1,:), expOut(1,:))
	verifyEqual(testCase, actOut(2,:), expOut(2,:))
	verifyEqual(testCase, actOut(3,:), expOut(3,:))
	verifyEqual(testCase, actOut(4,:), expOut(4,:))
end