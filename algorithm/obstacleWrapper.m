classdef obstacleWrapper < matlab.System
	% Wrapper to instantiate multiple obstacleTracker objects. 

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)
		obstacles;
	end

	% Pre-computed constants
	properties (Access = private)

	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function [obstaclesOut] = stepImpl(obj, detectIdx, detectPos, time)
			obstaclesOut = zeros(1, 8);
			for i = 1:8
				[obstacleOut.px, obstacleOut.py, obstacleOut.vx, obstacleOut.vy, obstacleOut.tracking] ...
					= obj.obstacles.step(time, detectPos.px, detectPos.py, bitget(detectIdx, i));
				obstaclesOut(k) = obstacleOut;
			end
		end

		function resetImpl(obj)
			% Initialize / reset discrete-state properties
			for i = 1:8
				obj.obstacles(i) = obstacleTracker;
			end
		end
	end
end
