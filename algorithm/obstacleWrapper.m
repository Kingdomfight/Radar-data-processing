classdef obstacleWrapper < matlab.System
	% Wrapper to instantiate multiple obstacleTracker objects. 

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)
		o;
	end

	% Pre-computed constants
	properties (Access = private)

	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function [obstaclesOut] = stepImpl(obj, detected, P, t)
			for k = 1:8
				[obstacleOut.Px, obstacleOut.Py, obstacleOut.Vx, obstacleOut.Vy, obstacleOut.Active] ...
					= obj.o.step(t, P(k).x, P(k).y, bitget(detected, k));
				obstaclesOut(k) = obstacleOut;
			end
		end

		function resetImpl(obj)
			% Initialize / reset discrete-state properties
			for k = 1:8
				obj.o(k) = obstacleTracker;
			end
		end
	end
end
