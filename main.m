clear
clc

sim = sim('Radar.slx');

t = sim.tout;

warning = sim.output.Data(1,1,:);
n = sim.output.Data(1,2,:);
pointX = sim.output.Data(:,3:10,:);
pointY = sim.output.Data(:,11:18,:);

angle = sim.radarData.Data(:,1);
distance = sim.radarData.Data(:,2);

Py = sim.obstacleData.Data(:,1);
Px = sim.obstacleData.Data(:,2);

samples = 25001;

%Setup figure
figure
grid on
hold on
xlim([-20 20])
ylim([-20 20])
xlabel('X-Coordinate (m)');
ylabel('Y-Coordinate (m)');

%Draw circle
syms x y
c = x^2 + y^2 == 4^2;
fimplicit(c)

gr = plot(0,1);
go = plot(0,0);
gd(1:8) = plot(0,0);

for i = 1:samples
    xr = 20*cosd(angle(i));
    yr = 20*sind(angle(i));
    set(gr,'XData',[0 xr]);
    set(gr,'YData',[0 yr]);

    set(go,'XData',Px(i));
    set(go,'YData',Py(i));

    set(gd,'XData',pointX(i));
    set(gd,'YData',pointY(i));

    F(i) = getframe();
end

movie(F,1,1000)