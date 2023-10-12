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

		function [Px, Py, Vx, Vy, Active] = stepImpl(obj, t, newX, newY, detected)
			% Implement algorithm. Calculate y as a function of input u and
			% discrete states.
			for k = 1:8
				[Px(k), Py(k), Vx(k), Vy(k), Active(k)] = obj.o(k).step(t(k), newX(k), newY(k), detected(k));
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
