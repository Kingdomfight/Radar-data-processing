classdef resolverDecoder < matlab.System
	% System object to convert resolver output (sine and cosine) to angle
	%
	% Input sine and cosine are scalars in the interval [-1, 1].
	% Represent the sine and cosine output of the resolver.
	%
	% Output is the calculated angle in degrees in the interval [0, 360).

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)

	end

	% Pre-computed constants
	properties (Access = private)

	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function angle = stepImpl(~, sine, cosine)
			% Input checking
			arguments
				~
				sine (1,1) {mustBeInRange(sine, -1, 1)}
				cosine (1,1) {mustBeInRange(cosine, -1, 1)}
			end

			angle = cordicatan2(sine, cosine);
			angle = angle*(180/pi);
			if angle < 0
				angle = angle + 360;
			end
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end

		function sizeOut = getOutputSizeImpl(~)
			sizeOut = [1 1];
		end

		function fixedOut = isOutputFixedSizeImpl(~)
			fixedOut = true;
		end

		function dataOut = getOutputDataTypeImpl(~)
			dataOut = 'double';
		end

		function complexOut = isOutputComplexImpl(~)
			complexOut = false;
		end
	end
end