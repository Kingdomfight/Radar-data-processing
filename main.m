clear
clc

simParam.radius = 4;
simParam.threshold = 5;
simParam.maxObst = 8;
simParam.time = 25;
sim = sim('Radar.slx', 'StartTime', '0', 'StopTime', string(simParam.time));

t = sim.tout;

output.warning  = squeeze(sim.output.Data(1,1,:));
output.n        = squeeze(sim.output.Data(1,2,:));
output.xOut     = squeeze(sim.output.Data(1,3:2+simParam.maxObst,:));
output.yOut     = squeeze(sim.output.Data(1,3+simParam.maxObst:2+2*simParam.maxObst,:));

angle = sim.radarData.Data(:,1);

input.yData = squeeze(sim.obstacleData.Data(1,1:simParam.maxObst,:));
input.xData = squeeze(sim.obstacleData.Data(1,1+simParam.maxObst:2*simParam.maxObst,:));

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
gCircle = x^2 + y^2 == simParam.radius^2;
fimplicit(gCircle)

gRadar = plot(0,0);
for i = 1:3
    gData(i) = plot(0,0, '.', 'MarkerSize', 25, 'Color', 'yellow');
end
gText = annotation('textbox', [0.27 1 0.5 0], 'string', 'start', 'HorizontalAlignment','center');
for i = 1:simParam.maxObst
    gOut(i) = plot(0, 0);
end

previousN = 0;
for i = 1:20:simParam.time*1000+1
    radar.x = 30*cosd(angle(i));
    radar.y = 30*sind(angle(i));
    set(gRadar,'XData',[0 radar.x]);
    set(gRadar,'YData',[0 radar.y]);

    for j = 1:3
        set(gData(j),'XData',input.xData(j,i));
        set(gData(j),'YData',input.yData(j,i));
    end

    if previousN < output.n(i)
        set(gOut(output.n(i)), 'Marker', '.', 'MarkerSize', 20, 'Color', 'red');
        previousN = output.n(i);
    end
    for j = 1:output.n(i)
        set(gOut(j),'XData',output.xOut(j,i));
        set(gOut(j),'YData',output.yOut(j,i));
    end

    if output.warning(i) == 1
        set(gText, 'String', 'Collision course');
    else
        set(gText, 'String', 'Safe');
    end

    [~] = getframe();
end