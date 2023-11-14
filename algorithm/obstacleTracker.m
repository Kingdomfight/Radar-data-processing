classdef obstacleTracker < matlab.System
	% The obstacleTracker system object can continuously keep track of a
	% singal obstacle, extrapolating position based on velocity and updating
	% velocity based on newly detected position.
	%
	% Inputs newX and newY indicate the newly detected position.
	% Input t indicates the current time.
	% Input detected indicates if the obstacle has beend detected.
	%    0: newX and newY are ignored and the current position is extrapolated.
	%    1: current position is updated to new position and velocity is 
	%        (re)calculated.
	%
	% Outputs px and py indicate the (extrapolated) position of the obstacle.
	%    These outputs are 0 if the obstacle isn't being tracked.
	% Outputs vx and vy indicate the last calculated velocity of the obstacle.
	%    Until the obstacle has beend detected twice these outputs are 0.
	% Output tracking indicates if the object is tracking an obstacle. If no
	% obstacle is being tracked the other outputs are all 0.

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)
		px
		py
		pxExt
		pyExt
		vx
		vy
		lastDetectedTime
		lastStepTime
		tracking
	end

	% Pre-computed constants
	properties (Access = private)

	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function [px, py, vx, vy, tracking] = stepImpl(obj, t, newX, newY, detected)
			if detected
				if obj.tracking
					obj.vx = (newX-obj.px)/(t-obj.lastDetectedTime);
					obj.vy = (newY-obj.py)/(t-obj.lastDetectedTime);
				end
				obj.px = newX; obj.pxExt = newX;
				obj.py = newY; obj.pyExt = newY;
				obj.tracking = true;
				obj.lastDetectedTime = t;
			elseif obj.tracking
				obj.pxExt = obj.pxExt + obj.vx*(t-obj.lastStepTime);
				obj.pyExt = obj.pyExt + obj.vy*(t-obj.lastStepTime);
			end

			px = obj.pxExt;
			py = obj.pyExt;
			vx = obj.vx;
			vy = obj.vy;
			obj.lastStepTime = t;
			tracking = obj.tracking;
		end

		function resetImpl(obj)
			% Initialize / reset discrete-state properties
			obj.px = 0;
			obj.py = 0;
			obj.pxExt = 0;
			obj.pyExt = 0;
			obj.vx = 0;
			obj.vy = 0;
			obj.lastDetectedTime = 0;
			obj.lastStepTime = 0;
			obj.tracking = false;
		end
	end
end
