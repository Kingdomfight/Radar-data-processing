clear

t = 0:0.000001:20;
Pos = P;
Pos.y = 10-t;
Pos.x = 10;

degrees = 360*((t+0.5)-fix(t+0.5)) - 180;
z = abs(atan2(Pos.y, Pos.x) - degrees*(pi/180));
Z = [];
for i = 1:numel(z)
    if z(i) < 1E-5
        Z = [Z, t(i)];
    end
end
prev = Z(1);
% Y = [];
res = [];
set = 1;
for i=2:numel(Z)
    if Z(i) < prev
        set = 1;
        prev = Z(i);
    elseif set == 1
        res = [res, Z(i)];
        prev = Z(i);
        set = 0;
    end
end