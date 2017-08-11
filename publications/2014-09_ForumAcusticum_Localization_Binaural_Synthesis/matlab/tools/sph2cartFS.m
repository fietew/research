% Frank Schultz, Uni Rostock
% 08.04.13
% EL...elevation, 0...pi, von der positiven z-Achse kommend, nach negative z-Achse laufend
% AZ...azimuth, 0...2pi, von der positiven x-Achse kommend, im positiven Winkel (d.h. zuerst nach positive y-Achse laufend) in der xy-Ebene
% diese Konvention ist anders als Matlab!
function [x,y,z] = sph2cartFS(EL,AZ,r)
    x = r.*sin(EL).*cos(AZ);
    y = r.*sin(EL).*sin(AZ);
    z = r.*cos(EL);
end