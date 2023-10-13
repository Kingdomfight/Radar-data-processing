classdef zoneCheck < matlab.System
	% Checks if any obstacles o come within a 5 meter radius of the radar.

	% Public, tunable properties
	properties

	end

	properties (DiscreteState)

	end

	% Pre-computed constants
	properties (Access = private)
		radius = 5;
		timeThreshold = 5;
	end

	methods (Access = protected)
		function setupImpl(~)
			% Perform one-time calculations, such as computing constants
		end

		function warning = stepImpl(obj,o)
			% Represent obstacle state vector as a line: y=ax+b
			a = o.Vy./o.Vx;
			b = o.Py - o.Px.*a;
			% Calculate discriminant system of equations of line and 
			% circle x^2+y^2=radius^2
			D = 4*((a*obj.radius).^2 - b.^2 + obj.radius^2);

			x1 = (-2*a.*b + sqrt(D))./(2*a.^2 + 2);
			x2 = (-2*a.*b - sqrt(D))./(2*a.^2 + 2);
			t1 = (x1 - o.Px)/o.Vx;
			t2 = (x2 - o.Px)/o.Vx;

			warning = any((isreal(t1) && t1 < obj.timeThreshold && t1 >= 0) ...
			| (isreal(t2) && t2 < obj.timeThreshold && t2 >= 0));
		end

		function resetImpl(~)
			% Initialize / reset discrete-state properties
		end
	end
end
