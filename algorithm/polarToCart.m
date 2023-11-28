classdef polarToCart < matlab.System
	% System object to convert polar coordinates (angle & distance) to
	% cartesian coordinates (out.px & out.py) for a 2D plane.
	%
	% Input angle is in degrees (0 <= degrees < 360)
	% Input distance is nonnegative
	%
	% This template includes the minimum set of functions required
	% to define a System object with discrete state.

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
			% Implement algorithm. Calculate y as a function of input u and
			% discrete states.

			% Input checking
			if (angle < 0 || angle >= 360)
				error('polarToCart:InputOutOfRange', ...
					'Angle must be >=0 and <360.')
			elseif (distance < 0)
				error('polarToCart:InputOutOfRange', ...
					'Distance must be nonnegative');
			end

			out.px = cosd(angle)*distance;
			out.py = sind(angle)*distance;
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end
	end
end
