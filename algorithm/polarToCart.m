classdef polarToCart < matlab.System
	% System object to convert polar coordinates (angle & distance) to
	% cartesian coordinates (x & y) for a 2D plane.
	%
	% Input angle is in degrees
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

		function [x, y] = stepImpl(~, angle, distance)
			% Implement algorithm. Calculate y as a function of input u and
			% discrete states.
			x = cosd(angle)*distance;
			y = sind(angle)*distance;
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end
	end
end
