classdef obstacle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Px
        Py
        Active
    end

    methods
        function obj = obstacle(Px,Py)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Px = Px;
            obj.Py = Py;
            obj.Active = false;
        end
    end
end