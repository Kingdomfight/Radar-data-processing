clear

%Setup figure
grid on
hold on
limit = [-20 20];
axis([limit limit]);
xlabel('X-Coordinate (m)');
ylabel('Y-Coordinate (m)');

%Text at the top of the figure
Gtext = annotation('textbox', [0.27 1 0.5 0], 'string', 'start', 'HorizontalAlignment','center');

%Draw circle
syms x y
c = x^2 + y^2 == 4^2;
fimplicit(c)

%Starting points
% Points(1) = P(10, 10);
% Points(2) = P(10, -10);
% Points(3) = P(-10, -10);
% Points(4) = P(-10, 10);

%Initialize obstacles
% O = zeros(1, 4);
% for i=1:1:4
%     O(i) = obstacle(Points(i));
% end

% P1 = zeros(1, 'P');
% O(1) = obstacle(P1);
time = 0;

for j = 1:1:100
    [P1.x, P1.y] = ginput(1);
    for i = 1:1:count
        z(i) = O(i).checkDistance(P1, 1);
    end
    [diff, zidx] = min(z);
    if (diff < 3)
        O(zidx) = O(zidx).newPoint(P1, 1);
    else
        count = count + 1;
        O(count) = obstacle(P1);
    end
    for i = 1:1:count
        if O(i).checkCollision()
            Gtext.String = 'Collision course';
            break;
        else
            Gtext.String = 'Safe';
        end
    end
    time = time + 5;
end