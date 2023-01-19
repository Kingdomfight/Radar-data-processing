classdef graph

    properties
        Gn      %Graph of new position
        Gl      %Graph of travel direction
        co      %Coefficients for travel line
        limit   %Size of the 2D grid
        T       %Interval over which the line is calculated
        f       %Y values of the line coresponding with T
        warning %1 if the line crosses the safe circle, 0 if not
    end

    methods
        function obj = graph(Pstart, limit)
            obj.Gn = plot(Pstart.x, Pstart.y, '.', 'MarkerSize', 20);
            obj.Gl = plot(Pstart.x, Pstart.y);
            obj.limit = limit;
            obj.T = Pstart.x;
            obj.f = Pstart.y;
        end

        function obj = redraw(obj)
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
    end

end