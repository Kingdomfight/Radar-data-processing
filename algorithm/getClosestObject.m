classdef getClosestObject < matlab.System
	% System object to calculate which tracked obstacle from input array trackedObs
	% is closest to input obstacle detectObs.
	% Input trackedObs is an vector of MAX_INPUT_OBSTACLES structs containing at
	% least the following fields:
	%   tracking: logical type used to check if obstacle is being tracked or not.
	%   pxExt: extrapolated x coordinate.
	%   pyExt: extrapolated y coordinate.
	% Input detectObs is a struct containing at elast the following fields:
	%   px: x coordinate of detected obstacle
	%   py: y coordinate of detected obstacle
	% Output c of type uint8 uses one-hot encoding to indicate the closest obstacle
	% in trackedObs. If there are no tracked obstacles in trackedObs, c is 0.

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)

	end

	% Pre-computed constants
	properties (Access = private)
		condition = @(obj) obj.tracking;
	end

	properties (Constant = true)
		MAX_INPUT_OBSTACLES = 8;
	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function c = stepImpl(obj, trackedObs, detectObs)
			% Input checking
			if (size(trackedObs, 2) > obj.MAX_INPUT_OBSTACLES)
				error('getClosestObject:InputIncorrectDimensions', ...
					'trackedObs must be a vector of at most 8 elements')
			end

			% Get tracked obstacles
			trackedObs = trackedObs(arrayfun(obj.condition, trackedObs));

			c = uint8(0);
			if size(trackedObs) ~= 0
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
