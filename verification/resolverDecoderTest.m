function tests = resolverDecoderTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = resolverDecoder();
end

function testSineInputCheck(testCase)
	cosine = 0;
	sine = 1+eps(1);
	functionHandle = @() testCase.TestData.dut(sine, cosine);
	testCase.verifyError(functionHandle, "MATLAB:validators:mustBeInRange");

	sine = -1-eps(-1);
	functionHandle = @() testCase.TestData.dut(sine, cosine);
	testCase.verifyError(functionHandle, "MATLAB:validators:mustBeInRange");

	sine = [0 0];
	functionHandle = @() testCase.TestData.dut(sine, cosine);
	testCase.verifyError(functionHandle, "MATLAB:validation:IncompatibleSize");
end

function testCosineInputCheck(testCase)
	sine = 0;
	cosine = 1+eps(1);
	functionHandle = @() testCase.TestData.dut(sine, cosine);
	testCase.verifyError(functionHandle, "MATLAB:validators:mustBeInRange");

	cosine = -1-eps(-1);
	functionHandle = @() testCase.TestData.dut(sine, cosine);
	testCase.verifyError(functionHandle, "MATLAB:validators:mustBeInRange");

	cosine = [0 0];
	functionHandle = @() testCase.TestData.dut(sine, cosine);
	testCase.verifyError(functionHandle, "MATLAB:validation:IncompatibleSize");
end

function testAllInputs(testCase)
	angles = 0:359;
	sine = sind(angles);
	cosine = cosd(angles);
	for itr = 360:-1:1
		actOut(itr) = testCase.TestData.dut(sine(itr), cosine(itr));
	end
	testCase.verifyEqual(single(actOut), single(angles));
end