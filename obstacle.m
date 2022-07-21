%Class for modeling obstacles

classdef obstacle
    properties
        Po      %Old position
        Pn      %New position
        Vx      %Horizontal speed
        Vy      %Vertical speed
        t_old   %Time of last detection
        Gn      %gGraph of new position
        Gl      %Graph of travel direction
        co      %Coefficients for travel line
        limit   %Size of the 2D grid
        T       %Interval over which the line is calculated
        f       %Y values of the line coresponding with T
        warning %1 if the line crosses the safe circle, 0 if not
    end
    methods
        %Constructor to initialize the obstacle as a point at Pstart on a
        %grid the size of limit*limit grid
        function obj = obstacle(Pstart, limit)
            if nargin > 0
                obj.Po = Pstart;
                obj.Pn = Pstart;
                obj.Vx = 0;
                obj.Vy = 0;
                obj.t_old = 0;
                obj.Gn = plot(Pstart.x, Pstart.y, '.', 'MarkerSize', 20);
                obj.Gl = plot(Pstart.x, Pstart.y);
                obj.limit = limit;
                obj.T = Pstart.x;
                obj.f = Pstart.y;
            end
        end

        %Method to recalculate the properties of obstacle for a new point
        %Pnew
        function obj = newPoint(obj, Pnew, t)
            if (Pnew.x > 20 || Pnew.x < -20)
                error('X-Coordinate out of reach')
            elseif(Pnew.y > 20 || Pnew.y < -20)
                error('Y-Coordinate out of reach')
            elseif(Pnew.x == obj.Pn.x && Pnew.y == obj.Pn.y)
                error("New coordinates can't be the same")
            else
                obj.Pn = Pnew;
            end
            dt = t - obj.t_old;
            obj.Vx = (obj.Pn.x - obj.Po.x)/dt;
            obj.Vy = (obj.Pn.y - obj.Po.y)/dt;

            obj.Gn.XData = obj.Pn.x;
            obj.Gn.YData = obj.Pn.y;

            obj.co = polyfit([obj.Po.x obj.Pn.x], [obj.Po.y obj.Pn.y], 1);
            x_lim = obj.Vx*5 + obj.Pn.x;
            if obj.Pn.x > obj.Po.x
                obj.T = linspace(obj.Pn.x, x_lim, 100);
            else
                obj.T = linspace(x_lim, obj.Pn.x, 100);
            end
            obj.f = polyval(obj.co, obj.T);
            obj.Gl.XData = obj.T;
            obj.Gl.YData = obj.f;
            obj.Po = obj.Pn;
            
            obj.warning = 0;
            for i = 1:1:100
                if sqrt(obj.T(i)^2 + obj.f(i)^2) <= 4
                    obj.warning = 1;
                    break;
                end
            end
        end

        %Return the closest distance between the line and point P
        function out = checkClosest(obj, P, t)
            x = obj.Vx*t + obj.Po.x;
            y = obj.Vy*t + obj.Po.y;
            out = sqrt((P.x - x)^2 + (P.y - y)^2);
%             z = sqrt((P.x - obj.T).^2 + (P.y - obj.f).^2);
%             out = min(z);
        end
    end
end