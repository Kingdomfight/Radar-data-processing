classdef obstacleTracker < matlab.System
	% The obstacleTracker system object can continuously keep track of a
	% singal obstacle, updating position based on velocity and updating
	% velocity based on newly detected position.
	%
	% This template includes the minimum set of functions required
	% to define a System object with discrete state.

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)
		Px
		Py
		PxExt
		PyExt
		Vx
		Vy
		lastDetectedTime
		lastStepTime
		Active
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
			if detected
				if obj.Active
					obj.Vx = (newX-obj.x)/(t-obj.lastDetectedTime);
					obj.Vy = (newX-obj.y)/(t-obj.lastDetectedTime);
				end
				obj.Px, obj.PxExt = newX;
				obj.Py, obj.PyExt = newY;
				obj.Active = true;
				obj.lastDetectedTime = t;
			elseif obj.Active
				obj.PxExt = obj.PxExt + obj.Vx*(t-obj.lastStepTime);
				obj.PyExt = obj.PyExt + obj.Vy*(t-obj.lastStepTime);
			end

			Px = obj.PxExt;
			Py = obj.PyExt;
			Vx = obj.Vx;
			Vy = obj.Vy;
			obj.lastStepTime = t;
			Active = obj.Active;
		end

		function resetImpl(obj)
			% Initialize / reset discrete-state properties
			obj.Px = 0;
			obj.Py = 0;
			obj.PxExt = 0;
			obj.PyExt = 0;
			obj.Vx = 0;
			obj.Vy = 0;
			obj.lastDetectedTime = 0;
			obj.lastStepTime = 0;
			obj.Active = false;
		end
	end
end
