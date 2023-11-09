classdef getClosestObject < matlab.System
	% System object to calculate which tracked obstacle from input array trackedObs
	% is closest to input obstacle detectObs.
	% Input trackedObs is an array of structs containing at least the following fields:
	%   tracking: logical type used to check if obstacle is being tracked or not.
	%   pxExt: extrapolated x coordinate.
	%   pyExt: extrapolated y coordinate.
	% Input detectObs is a struct containing at elast the following fields:
	%   px: x coordinate of detected obstacle
	%   py: y coordinate of detected obstacle
	% Output c uses one-hot encoding to indicate the closest obstacle in trackedObs.
	% If there are no tracked obstacles in trackedObs, c is 0.

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)

	end

	% Pre-computed constants
	properties (Access = private)
		condition = @(obj) obj.Active;
	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function c = stepImpl(obj, trackedObs, detectObs)
			% Get tracked obstacles
			trackedObs = trackedObs(arrayfun(obj.condition, trackedObs));

			if size(trackedObs) == 0
				c = 0;
			else
				dx = [trackedObs.pxExt]-detectObs.px;
				dy = [trackedObs.pyExt]-detectObs.py;
				obstacleDistance = sqrt(dx.^2+dy.^2);
				[~, index] = min(obstacleDistance);
				c = bitshift(1, index-1);
			end
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end
	end
end
