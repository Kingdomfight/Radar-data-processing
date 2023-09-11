classdef radarAlgorithm < matlab.System
    % Algorithm to track objects with radar data

    % Public, tunable properties
    properties
        radius              %Radius of protected zone
        distanceThreshold   %Meximum distance error before new obstacle is created
    end

    properties (DiscreteState)
        count   %Number of tracked obstacles

        %Obstacle properties
        Px      %location
        Py      %location
        Lastx   %Last detected location
        Lasty   %Last detected location
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
            obj.Px = zeros(1,8);
            obj.Py = zeros(1,8);
            obj.Lastx = zeros(1,8);
            obj.Lasty = zeros(1,8);
            obj.Vx = zeros(1,8);
            obj.Vy = zeros(1,8);
            obj.t_old = zeros(1,8);
        end

        function [warning, n, pointX, pointY] = stepImpl(obj, angle, distance)
            %Get simulation time
            time = getCurrentTime(obj);
            dt = time - obj.t_old;
            z = zeros(1,8);

            %Update position of all objects
            obj.Px = obj.Vx.*dt + obj.Lastx;
            obj.Py = obj.Vy.*dt + obj.Lasty;

            if distance > 0
                %Convert euclidian values to carthesian values
                Pnew.x = distance*cos(angle*pi/180);
                Pnew.y = distance*sin(angle*pi/180);

                if obj.count == 0
                    obj.Px(1) = Pnew.x;
                    obj.Py(1) = Pnew.y;
                    obj.Lastx(1) = Pnew.x;
                    obj.Lasty(1) = Pnew.y;
                    obj.t_old(1) = time;
                    obj.count = 1;
                else
                    %Check distance to Pnew for all tracked obstacles
                    a = Pnew.x-obj.Px;
                    b = Pnew.y-obj.Py;
                    z = sqrt(a.^2 + b.^2);
                    
                    %Match point to closest obstacle
                    %If distance >= 3 create a new obstacle
                    [diff, zidx] = min(z(1:obj.count));
                    if (diff < obj.distanceThreshold)
                        obj.Vx(zidx) = (Pnew.x - obj.Lastx(zidx))/dt(zidx);
                        obj.Vy(zidx) = (Pnew.y - obj.Lasty(zidx))/dt(zidx);
                        obj.Px(zidx) = Pnew.x;
                        obj.Py(zidx) = Pnew.y;
                        obj.Lastx(zidx) = Pnew.x;
                        obj.Lasty(zidx) = Pnew.y;
                        obj.t_old(zidx) = time;
                    elseif obj.count < 8
                        obj.count = obj.count + 1;
                        obj.Px(obj.count) = Pnew.x;
                        obj.Py(obj.count) = Pnew.y;
                        obj.Lastx(obj.count) = Pnew.x;
                        obj.Lasty(obj.count) = Pnew.y;
                        obj.Vx(obj.count) = 0;
                        obj.Vy(obj.count) = 0;
                        obj.t_old(obj.count) = time;
                    end
                end
            end

            %Check if any obstacles come into protection zone
            % within 5 seconds
            ret = zeros(1,8);
            for i = 1:obj.count
                ret(i) = checkCollision(obj.Px(i), obj.Py(i), obj.Vx(i), obj.Vy(i), obj.radius);
            end
            if any(ret)
                warning = 1;
            else
                warning = 0;
            end

            n = obj.count;
            pointX = obj.Px;
            pointY = obj.Py;
        end

        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(~,name)
            switch name
                case 'Px'
                    sz = [1 8];
                    dt = 'double';
                case 'Py'
                    sz = [1 8];
                    dt = 'double';
                case 'Lastx'
                    sz = [1 8];
                    dt = 'double';
                case 'Lasty'
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
            obj.count = 0;
            obj.Px = zeros(1,8);
            obj.Py = zeros(1,8);
            obj.Lastx = zeros(1,8);
            obj.Lasty = zeros(1,8);
            obj.Vx = zeros(1,8);
            obj.Vy = zeros(1,8);
            obj.t_old = zeros(1,8);
        end
    end
end
