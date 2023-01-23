%Class for modeling obstacles

% classdef obstacle
%     properties
%         Px      %Horizontal location
%         Py      %Vertical location
%         Vx      %Horizontal speed
%         Vy      %Vertical speed
%         t_old   %Time of last detection
%         radius  %Radius of protected zone
%     end
%     methods
        %Constructor to initialize the obstacle as a point at Pstart
        function obj = obstacle(Pstart, t, r)
            if nargin > 0
                obj.Px = Pstart.x;
                obj.Py = Pstart.y;
                obj.Vx = 0;
                obj.Vy = 0;
                obj.t_old = t;
                obj.radius = r;
            end
        end

        %Method to update velocity and position based on poin Pnew
        function [t_old, V, P] = newPoint(t_old, P, Pnew, t)
            %Get time since last location update
            dt = t - t_old;

            %Get velocity
            V.x = (Pnew.x - P.x)/dt;
            V.y = (Pnew.y - P.y)/dt;

            %Update current position
            P.x = Pnew.x;
            P.y = Pnew.y;
            t_old = t;
        end

        function ret = checkCollision(Px, Py, Vx, Vy, radius)
            a = Vy/Vx;
            b = Py - Px*a;
            D = 4*(radius^2 - b^2 + (a*radius)^2);
            if D < 0
                ret = 0;
            else
                x1 = (-(2*a*b) + sqrt(D))/(2*a^2 + 2);
                x2 = (-(2*a*b) - sqrt(D))/(2*a^2 + 2);
                t1 = (x1 - Px)/Vx;
                t2 = (x2 - Px)/Vx;
                if (t1 < 5 & t1 > 0) | (t2 < 5 & t2 > 0)
                    ret = 1;
                else
                    ret = 0;
                end
            end
        end

        %Return the distance between predicted obstacle location and point P
        function err = checkDistance(t_old, V, P, Pnew, t)
            %Time since last location update
            dt = t - t_old;
            predictedX = V.x*dt + P.x;
            predictedY = V.y*dt + P.y;
            err = sqrt((Pnew.x - predictedX)^2 + (Pnew.y - predictedY)^2);
        end
%     end
% end