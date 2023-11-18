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