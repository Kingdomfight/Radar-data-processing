function tests = resolverDecoderTest
	tests = functiontests(localfunctions);
end

function setup(testCase)
	testCase.TestData.dut = resolverDecoder();
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