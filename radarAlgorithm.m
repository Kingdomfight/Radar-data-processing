classdef radarAlgorithm < matlab.System
    % Algorithm to track objects with radar data

    % Public, tunable properties
    properties
        radius          %Radius of protected zone
        angleThreshold  %Meximum angle error before new obstacle is created
    end

    properties (DiscreteState)
        z       %Error distances for all obstacles
        count   %Number of tracked obstacles
        O       %Array of obstacles
    end

    % Pre-computed constants
    properties (Access = private)

    end

    methods (Access = protected)
        function setupImpl(obj)
            %Setup figure
%             limit = [-20 20];
%             axis([limit limit]);

            %Initialize variables
            obj.z = 3;
            obj.count = 0;
            Pnew.x = 0;
            Pnew.y = 0;
            %Properties can't be objects
            %Need to fix
            obj.O = obstacle(Pnew, 0, obj.radius);
        end

        function [warning, n, pointX, pointY] = stepImpl(obj, angle, distance)
            %Get simulation time
            time = getCurrentTime(obj);

            %Convert euclidian values to carthesian values
            Pnew.x = distance*cosd(angle);
            Pnew.y = distance*sind(angle);

            %Check distance to Pnew for all tracked obstacles
            for i = 1:1:obj.count
                obj.z(i) = obj.O(i+1).checkDistance(Pnew, time);
            end

            %Match point to closest obstacle
            %If distance >= 3 create a new obstacle
            [diff, zidx] = min(obj.z);
            if (diff < obj.angleThreshold)
                obj.O(zidx+1).newPoint(Pnew, time);
            else
                obj.count = obj.count + 1;
                obj.O(obj.count+1) = obstacle(Pnew, time, obj.radius);
            end

            %Check if any obstacles come intoprotection zone
            % within 5 seconds
            for i = 1:1:obj.count
                if obj.O(i+1).checkCollision()
                    warning = 1;
                    break;
                else
                    warning = 0;
                end
            end

            n = obj.count;
            for i = 1:1:obj.count
                pointX(i) = obj.O(i+1).Px;
                pointY(i) = obj.O(i+1).Py;
            end
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
