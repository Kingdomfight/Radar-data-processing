classdef radarAlgorithm < matlab.System
    % Algorithm to track objects with radar data

    % Public, tunable properties
    properties
        radius          %Radius of protected zone
        angleThreshold  %Meximum angle error before new obstacle is created
        maxObst               %Maximum amount of obstacles
    end

    properties (DiscreteState)
        z       %Error distances for all obstacles
        count   %Number of tracked obstacles

        %Obstacle properties
        Px      %location
        Py      %location
        Vx       %velocity
        Vy       %velocity
        t_old   %Time of last detection
    end

    % Pre-computed constants
    properties (Access = protected)
    end

    methods (Access = protected)
        function setupImpl(obj)
            %Initialize variables
            obj.count = 0;
            obj.z = 3:10;
            obj.Px = 1:8;
            obj.Py = 1:8;
            obj.Vx = 1:8;
            obj.Vy = 1:8;
            obj.t_old = 1:8;
        end

        function [warning, n, pointX, pointY] = stepImpl(obj, angle, distance)
            %Get simulation time
            time = getCurrentTime(obj);

            %Convert euclidian values to carthesian values
            Pnew.x = distance*cosd(angle);
            Pnew.y = distance*sind(angle);

            %Update position of all objects
            for h = 1:obj.count
                dt = time - obj.t_old(h);
                obj.Px = obj.Vx*dt + obj.Px(h);
                obj.Py = obj.Vy*dt + obj.Py(h);
            end

            %Check distance to Pnew for all tracked obstacles
            obj.z = 3:10;
            obj.z(:) = 1000000;
            for i = 1:obj.count
                obj.z(i) = sqrt((obj.Px(i)-Pnew.x)^2 + (obj.Py(i)-Pnew.x)^2);
            end

            %Match point to closest obstacle
            %If distance >= 3 create a new obstacle
            if distance > 0
                [diff, zidx] = min(obj.z(1:8));
                if (diff < obj.angleThreshold & obj.count > 0)
                    dt = time - obj.t_old(zidx);
                    obj.Vx(zidx) = (Pnew.x - obj.Px(zidx))/dt;
                    obj.Vy(zidx) = (Pnew.y - obj.Py(zidx))/dt;

                    obj.Px(zidx) = Pnew.x;
                    obj.Py(zidx) = Pnew.y;

                    obj.t_old(zidx) = time;
                elseif obj.count < 8
                    obj.count = obj.count + 1;
                    obj.Px(obj.count) = Pnew.x;
                    obj.Py(obj.count) = Pnew.y;
                    obj.Vx(obj.count) = 0;
                    obj.Vy(obj.count) = 0;
                    obj.t_old(obj.count) = time;
                end
            end

            %Check if any obstacles come into protection zone
            % within 5 seconds
            warning = 0;
            for j = 1:obj.count
                if checkCollision(obj.Px(j), obj.Py(j), obj.Vx(j), obj.Vy(j), obj.radius)
                    warning = 1;
                    break;
                end
            end

            n = obj.count;
            pointX = zeros(1, 8);
            pointY = zeros(1, 8);
            pointX(1:obj.count) = obj.Px(1:obj.count);
            pointY(1:obj.count) = obj.Py(1:obj.count);
        end

        function [Px,Py] = predictPosition(Px,Py,Vx,Vy,t_old,time)
            dt = time - t_old;
            Px = Vx*dt + Px;
            Py = Vy*dt + Py;
        end

        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(~,name)
            switch name
                case 'Px'
                    sz = [1 8];
                    dt = 'double';
                case 'Py'
                    sz = [1 8];
                    dt = 'double';
                case 'Vx'
                    sz = [1 8];
                    dt = 'double';
                case 'Vy'
                    sz = [1 8];
                    dt = 'double';
                case 't_old'
                    sz = [1 8];
                    dt = 'double';
                case 'z'
                    sz = [1 8];
                    dt = 'double';
                case 'count'
                    sz = [1 1];
                    dt = 'double';
            end
            cp = false;
        end

        function [c1, c2, c3, c4] = isOutputFixedSizeImpl(~)
            c1 = true;
            c2 = true;
            c3 = true;
            c4 = true;
        end

        function [sz_1,sz_2,sz_3,sz_4] = getOutputSizeImpl(~)
            sz_1 = [1 1];
            sz_2 = [1 1];
            sz_3 = [1 8];
            sz_4 = [1 8];
        end

        function [dt_1,dt_2,dt_3,dt_4] = getOutputDataTypeImpl(~)
            dt_1 = 'double';
            dt_2 = 'double';
            dt_3 = 'double';
            dt_4 = 'double';
        end

        function [c1,c2,c3,c4] = isOutputComplexImpl(~)
            c1 = false;
            c2 = false;
            c3 = false;
            c4 = false;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.z = 3:10;
            obj.count = 0;
        end
    end
end
