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

	end

	% Pre-computed constants
	properties (Access = private)
		obstacles;
	end

	properties (Constant = true)
		NUM_OBSTACLE_TRACKER = 8; % TODO: make global
	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function obstaclesOut = stepImpl(obj, detectIdx, detectPos, time)
			% Input checking
			if (~isa(detectIdx, 'uint8'))
				error('obstacleWrapper:IncorrectInputType', ...
					'obstacleWrapper input detectIdx must be of type uint8');
			elseif (~ismember(detectIdx, [0 2.^(0:7)]))
				error('obstacleWrapper:IncorrectInputValue', ...
				'obstacleWrapper input detectIdx must be 0 or power of 2');
			end

			for i = obj.NUM_OBSTACLE_TRACKER:-1:1
				[obstacleOut.px, obstacleOut.py, obstacleOut.vx, obstacleOut.vy, obstacleOut.tracking] ...
					= obj.obstacles{i}.step(time, detectPos.px, detectPos.py, bitget(detectIdx, i));
				obstaclesOut(i) = obstacleOut;
			end
		end

		function resetImpl(obj)
			% Initialize / reset discrete-state properties
			obj.obstacles = cell(1, obj.NUM_OBSTACLE_TRACKER);
			for i = 1:obj.NUM_OBSTACLE_TRACKER
				obj.obstacles{i} = obstacleTracker;
			end
		end

		function sizeOut = getOutputSizeImpl(obj)
			sizeOut = [1 obj.NUM_OBSTACLE_TRACKER];
		end

		function fixedOut = isOutputFixedSizeImpl(~)
			fixedOut = true;
		end

		function dataOut = getOutputDataTypeImpl(~)
			dataOut = 'Bus: obstacleBus';
		end

		function complexOut = isOutputComplexImpl(~)
			complexOut = false;
		end
	end
end
