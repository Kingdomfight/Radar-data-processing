classdef getClosestObject < matlab.System
	% System object to calculate which tracked obstacle from input array trackedObs
	% is closest to input obstacle detectObs.
	% Input trackedObs is an vector of MAX_INPUT_OBSTACLES structs containing at
	% least the following fields:
	%   tracking: logical type used to check if obstacle is being tracked or not.
	%   px: x coordinate.
	%   py: y coordinate.
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
			elseif (~isfield(trackedObs, 'px') || ~isfield(trackedObs, 'py') ...
				|| ~isfield(trackedObs, 'tracking'))
				error('getClosestObject:InputIncorrectFields', ...
				'trackedObs must be a structure array containing fields px, py, and tracking')
			elseif (~isfield(detectObs, 'px') || ~isfield(detectObs, 'py'))
				error('getClosestObject:InputIncorrectFields', ...
				'detectObs must be a struct containing fields px and py')
			end

			if all([trackedObs(:).tracking] == false)
				c = uint8(0);
			else
				obstacleDistance = ones(1, obj.MAX_INPUT_OBSTACLES)*realmax;
				for i=1:obj.MAX_INPUT_OBSTACLES
					if trackedObs(i).tracking
						dx = [trackedObs(i).px]-detectObs.px;
						dy = [trackedObs(i).py]-detectObs.py;
						obstacleDistance(i) = sqrt(dx.^2+dy.^2);
					end
				end
				[~, index] = min(obstacleDistance);
				c = bitshift(uint8(1), index-1);
			end
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end

		function sizeOut = getOutputSizeImpl(~)
			sizeOut = [1 1];
		end

		function fixedOut = isOutputFixedSizeImpl(~)
			fixedOut = true;
		end

		function dataOut = getOutputDataTypeImpl(~)
			dataOut = 'uint8';
		end

		function complexOut = isOutputComplexImpl(~)
			complexOut = false;
		end
	end
end
