function x0 = linear(s,Xc)

% secondary sources
x0(:,1) = Xc(1) + s;
x0(:,2) = Xc(2);
x0(:,3) = Xc(3);
x0(:,4) = 0;
x0(:,5) = -1;
x0(:,6) = 0;