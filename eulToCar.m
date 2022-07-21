function Pnew = eulToCar(a, D)
    Pnew = P;
    Pnew.x = D*cosd(a);
    Pnew.y = D*sind(a);
end