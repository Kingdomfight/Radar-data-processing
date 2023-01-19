%Class for modeling obstacles

classdef obstacle
    properties
        Px      %Horizontal location
        Py      %Vertical location
        Vx      %Horizontal speed
        Vy      %Vertical speed
        t_old   %Time of last detection
%         Gl      %Line of current heading
        radius  %Radius of protected zone
    end
    methods
        %Constructor to initialize the obstacle as a point at Pstart on a
        %grid the size of limit*limit grid
        function obj = obstacle(Pstart, t, r)
            if nargin > 0
                obj.Px = Pstart.x;
                obj.Py = Pstart.y;
                obj.Vx = 0;
                obj.Vy = 0;
                obj.t_old = t;
%                 obj.Gl = plot(Pstart.x, Pstart.y);
                obj.radius = r;
            end
        end

        %Method to update velocity and position based on poin Pnew
        function newPoint(obj, Pnew, t)
            %Get time since last location update
            dt = t - obj.t_old;

            %Get velocity
            obj.Vx = (Pnew.x - obj.Px)/dt;
            obj.Vy = (Pnew.y - obj.Py)/dt;

            %Update current position
            obj.Px = Pnew.x;
            obj.Py = Pnew.y;
            obj.t_old = t;

            %Redraw line
%             obj.Gl.XData = [obj.Px (obj.Px + obj.Vx*5)];
%             obj.Gl.YData = [obj.Py (obj.Py + obj.Vy*5)];
        end

        function ret = checkCollision(obj)
            syms t
            %Distance to radar function
            x = obj.Vx*t + obj.Px;
            y = obj.Vy*t + obj.Py;
            z = sqrt(x^2 + y^2);
            res = solve(z < obj.radius, t);
            if (isreal(res) & res < 5 & res > 0)
                ret = 1;
            else
                ret = 0;
            end
        end

        %Return the distance between predicted obstacle location and point P
        function err = checkDistance(obj, P, t)
            %Time since last location update
            dt = t - obj.t_old;
            predictedX = obj.Vx*dt + obj.Px;
            predictedY = obj.Vy*dt + obj.Py;
            err = sqrt((P.x - predictedX)^2 + (P.y - predictedY)^2);
        end
    end
end