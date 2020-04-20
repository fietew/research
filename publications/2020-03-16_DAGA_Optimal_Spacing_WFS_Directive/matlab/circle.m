function x0 = circle(s,R)

% secondary sources
x0(:,1) = R*cos(s./R);
x0(:,2) = R*sin(s./R);
x0(:,3) = 0;
x0(:,4) = -cos(s./R);
x0(:,5) = -sin(s./R);
x0(:,6) = 0;