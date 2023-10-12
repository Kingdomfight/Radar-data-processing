classdef getClosestObject < matlab.System
	% System object to calculate which input object P(1)...P(n) is closest to
	% input object F. Input n controls how many objects P need to be
	% checked. Output C uses one-hot encoding to indicate the closest P object.
	% If there are no active P objects C is 0.

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

		function C = stepImpl(obj, P, F)
			% Get active obstacles
			onObjects = P(arrayfun(obj.condition, P));

			if size(onObjects) == 0
				C = 0;
			else
				dx = [onObjects.Px]-F.x;
				dy = [onObjects.Py]-F.y;
				obstacleDistance = sqrt(dx.^2+dy.^2);
				[~, index] = min(obstacleDistance);
				C = bitshift(1, index-1);
			end
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end
	end
end
