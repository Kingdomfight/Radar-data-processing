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
			% Represent obstacle state vector as a line: y=ax+b
			a = obsState.vy./obsState.vx;
			b = obsState.py - obsState.px.*a;
			% Calculate discriminant system of equations of line and 
			% circle x^2+y^2=RADIUS^2
			D = 4*((a*obj.RADIUS).^2 - b.^2 + obj.RADIUS^2);

			x1 = (-2*a.*b + sqrt(D))./(2*a.^2 + 2);
			x2 = (-2*a.*b - sqrt(D))./(2*a.^2 + 2);
			t1 = (x1 - obsState.px)/obsState.vx;
			t2 = (x2 - obsState.px)/obsState.vx;

			warning = any((isreal(t1) && t1 < obj.TIME_THRESHOLD && t1 >= 0) ...
			| (isreal(t2) && t2 < obj.TIME_THRESHOLD && t2 >= 0));
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end
	end
end
