function ret = checkCollision(Px, Py, Vx, Vy, radius)
    a = Vy/Vx;
    b = Py - Px*a;
    D = 4*(radius^2 - b^2 + (a*radius)^2);
    if D < 0
        ret = 0;
    else
        x1 = (-(2*a*b) + sqrt(D))/(2*a^2 + 2);
        x2 = (-(2*a*b) - sqrt(D))/(2*a^2 + 2);
        t1 = (x1 - Px)/Vx;
        t2 = (x2 - Px)/Vx;
        if (t1 < 5 & t1 > 0) | (t2 < 5 & t2 > 0)
            ret = 1;
        else
            ret = 0;
        end
    end
end