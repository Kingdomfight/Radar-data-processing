classdef obstacleWrapper < matlab.System
	% Wrapper to instantiate NUM_OBSTACLE_TRACKER obstacleTracker objects.
	% Input detectIdx needs to be of type uint8. Uses one-hot encoding to select which
	% obstacleTracker object (if any) needs to be updated.
	% Input detectPos contains at least the following fields:
	%   px: x coordinate of newly detected obstacle.
	%   py: y coordinate of newly detected obstacle.
	% Input time specifies the time from the start of the current time from the start of
	% the simulation.
	% Output obstaclesOut is a 1 x NUM_OBSTACLE_TRACKER vector of structs containing the
	% outputs of the obstacleTracker objects. See obstacleTracker for fields of the structs.

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)
		obstacles;
	end

	% Pre-computed constants
	properties (Access = private)

	end

	properties (Constant = true)
		NUM_OBSTACLE_TRACKER = 8; % TODO: make global
	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function [obstaclesOut] = stepImpl(obj, detectIdx, detectPos, time)
			obstaclesOut = zeros(1, obj.NUM_OBSTACLE_TRACKER);
			for i = 1:obj.NUM_OBSTACLE_TRACKER
				[obstacleOut.px, obstacleOut.py, obstacleOut.vx, obstacleOut.vy, obstacleOut.tracking] ...
					= obj.obstacles.step(time, detectPos.px, detectPos.py, bitget(detectIdx, i));
				obstaclesOut(k) = obstacleOut;
			end
		end

		function resetImpl(obj)
			% Initialize / reset discrete-state properties
			for i = 1:obj.NUM_OBSTACLE_TRACKER
				obj.obstacles(i) = obstacleTracker;
			end
		end
	end
end
