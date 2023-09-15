classdef obstacleTracker < matlab.System
    % The obstacleTracker system object can continuously keep track of a
    % singal obstacle, updating position based on velocity and updating
    % velocity based on newly detected position.
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        Px
        Py
        Vx
        Vy
        lastDetectedTime
        lastStepTime
        Active
    end

    properties (DiscreteState)

    end

    % Pre-computed constants
    properties (Access = private)

    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.lastDetectedTime = 0;
            obj.lastStepTime = 0;
            obj.Active = false;
        end

        function [Px, Py, Vx, Vy, Active] = stepImpl(obj, t, newX, newY, detected)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            if ~detected
                obj.Active = true;
                dt = t-obj.lastStepTime;
                obj.Px = obj.Px + obj.Vx*dt;
                obj.Py = obj.Py + obj.Vy*dt;
            else
                dt = t-obj.lastDetectedTime;
                obj.Vx = (newX - obj.Px) / dt;
                obj.Vy = (newY - obj.Py) / dt;
                obj.Px = newX;
                obj.Py = newY;
                obj.lastDetectedTime = t;
            end
            Px = obj.Px;
            Py = obj.Py;
            Vx = obj.Vx;
            Vy = obj.Vy;
            obj.lastStepTime = t;
            Active = obj.Active;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
