function tests = obstacleWrapperTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = obstacleWrapper();
end

function testInputChecking(testCase)
	detectPos = struct('px', 0, 'py', 0);
	functionHandle = @() testCase.TestData.dut(5, detectPos, 0);
	verifyError(testCase, functionHandle, 'obstacleWrapper:IncorrectInputType');
end