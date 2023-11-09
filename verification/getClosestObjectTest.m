function tests = getClosestObjectTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = getClosestObject();
end

function test0Objects(testCase)
	tracked.tracking = false;
	tracked.px = 0;
	tracked.py = 0;
	detect.px = 0;
	detect.py = 0;
	actOutput = testCase.TestData.dut(tracked, detect);
	expOutput = uint8(0);
	verifyEqual(testCase, actOutput, expOutput);
end

function testMaxObjects(testCase)
	inputSize = testCase.TestData.dut.MAX_INPUT_OBSTACLES;
	tracked.tracking = false;
	tracked.pxExt = 0;
	tracked.pyExt = 0;
	tracked = repmat(tracked, 1, inputSize);
	detect.px = 0;
	detect.py = 0;
	actOutput = testCase.TestData.dut(tracked, detect);
	expOutput = uint8(0);
	verifyEqual(testCase, actOutput, expOutput);
end