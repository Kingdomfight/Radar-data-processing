classdef zoneCheck < matlab.System
	% Checks if any obstacles in array obsState enter a RADIUS meter radius
	% around the radar in the next TIME_THRESHOLD seconds. Only obstacles
	% actively tracking are checked.
	% Input obsState is an array of structs containing the state variables
	% of obstacleTracker objects. These include:
	%   px: x coordinate
	%   py: y coordinate
	%   vx: x velocity
	%   vy: y velocity
	%   tracking: obstacleTracker object is tracking object(true) or not(false)
	% Output warning is true if an obstacleTracker object will enter a RADIUS
	% meter radius around the radar in the next TIM_THRESHOLD seconds.

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)

	end

	% Pre-computed constants
	properties (Access = private)

	end

	properties (Constant = true)
		RADIUS = 5;
		TIME_THRESHOLD = 5;
	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function warning = stepImpl(obj, obsState)
			% Format input into struct of arrays
			input.px = [obsState.px];
			input.py = [obsState.py];
			input.vx = [obsState.vx];
			input.vy = [obsState.vy];
			input.tracking = [obsState.tracking];
			% Avoid divide by zero condition
			input.vx = input.vx + eps(0.^input.vx);
			input.vy = input.vy + eps(0.^input.vy);
			% Check if obstacle already in zone
			if (any(sqrt(input.px.^2 + input.py.^2) <= obj.RADIUS))
				warning = true;
			else
				a = input.vy./input.vx;
				b = input.py - input.px.*a;
				% Calculate discriminant system of equations of line and 
				% circle x^2+y^2=RADIUS^2
				D = 4*((a*obj.RADIUS).^2 - b.^2 + obj.RADIUS^2);

				x1 = (-2*a.*b + sqrt(D))./(2*a.^2 + 2);
				x2 = (-2*a.*b - sqrt(D))./(2*a.^2 + 2);
				t1 = (x1 - input.px)./input.vx;
				t2 = (x2 - input.px)./input.vx;

				cond1 = arrayfun(@(time1) isreal(time1) && time1 < obj.TIME_THRESHOLD && time1 >= 0, t1);
				cond2 = arrayfun(@(time2) isreal(time2) && time2 < obj.TIME_THRESHOLD && time2 >= 0, t2);
				warning = any(arrayfun(@(c1, c2) c1 || c2, cond1, cond2));
			end
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end
	end
end
