function tests = getClosestObjectTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = getClosestObject();
end

function test0Objects(testCase)
	tracked = struct('tracking', false, 'px', 0, 'py', 0);
	detect = struct('px', 0, 'py', 0);
	actOutput = testCase.TestData.dut(tracked, detect);
	expOutput = uint8(0);
	verifyEqual(testCase, actOutput, expOutput);
end

function testMaxObjects(testCase)
	inputSize = testCase.TestData.dut.MAX_INPUT_OBSTACLES;
	tracked = struct('tracking', false, 'px', 0, 'py', 0);
	tracked = repmat(tracked, 1, inputSize);
	detect = struct('px', 0, 'py', 0);
	actOutput = testCase.TestData.dut(tracked, detect);
	expOutput = uint8(0);
	verifyEqual(testCase, actOutput, expOutput);
end

function test2ManyObjects(testCase)
	inputSize = testCase.TestData.dut.MAX_INPUT_OBSTACLES+1;
	tracked = struct('tracking', false, 'px', 0, 'py', 0);
	tracked = repmat(tracked, 1, inputSize);
	detect = struct('px', 0, 'py', 0);
	functionHandle = @() testCase.TestData.dut(tracked, detect);
	verifyError(testCase, functionHandle, 'getClosestObject:InputIncorrectDimensions');
end