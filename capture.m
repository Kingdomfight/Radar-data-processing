classdef capture < matlab.System
    % untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties

    end

    properties (DiscreteState)
        count;
        m;
        g;
        gText;
    end

    % Pre-computed constants
    properties (Access = private)

    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.count = 0;
            obj.g = plot(0, 0, '.', 'MarkerSize', 20);
            obj.gText = annotation('textbox', [0.27 1 0.5 0], 'string', 'start', 'HorizontalAlignment','center');
        end

        function stepImpl(obj, warning, c, Px, Py)
            set(obj.g(1:c),'XData',Px(1:c));
            set(obj.g(1:c),'YData',Py(1:c));

            if warning
                set(obj.gText,'String','Collision course');
            else
                set(obj.gText,'String','Safe');
            end

            obj.count = obj.count + 1;
            obj.m(obj.count) = getframe;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end