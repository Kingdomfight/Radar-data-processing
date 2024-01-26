classdef polarToCart < matlab.System
	% System object to convert polar coordinates (angle & distance) to
	% cartesian coordinates (out.px & out.py) for a 2D plane.
	%
	% Input angle in degrees in interval [0, 360)
	% Input distance is in interval [0, inf)

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

		function out = stepImpl(~, angle, distance)
			angle = angle*(pi/180);
			[sine, cosine] = cordicsincos(angle);

			out.px = cosine*distance;
			out.py = sine*distance;
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
			dataOut = 'Bus: cartBus';
		end

		function complexOut = isOutputComplexImpl(~)
			complexOut = false;
		end
	end
end
