function evalPlotLocalizationError(out, xshift, rot, params)
%EVALPLOTLOCALIZATIONERROR Summary of this function goes here
%   Detailed explanation goes here

Nrot = length(rot);
Nplot = ceil(sqrt(Nrot));

x_lim = norm(params.source.position);
y_lim = norm(params.source.position);

figure;
for kdx=1:Nrot 
  x = xshift(:,1);
  y = xshift(:,2);
  u = cosd(out.phi(:,kdx)).*out.delta(:,kdx);
  v = sind(out.phi(:,kdx)).*out.delta(:,kdx);
  
  subplot(Nplot,Nplot, kdx);
  
  quiverc(x,y,u,v,0.5);
  %set(gca, 'color', [0 0 0]);
  %set(gcf, 'color', [0 0 0]);
  hold on
  % draw circle for microphone array
  h = rectangle('Position',[-params.R, -params.R, 2*params.R, 2*params.R]);
  set(h,'Curvature', [1, 1]);
  set(h,'EdgeColor',[0 0 0]);  
  
  % draw source
  M = makehgtform('zrotate',rot(kdx));  
  source_pos = params.source.position*M(1:3,1:3)';
  source_pos = [source_pos 1 0 0 1];
  draw_loudspeakers(source_pos, [1 1 0], params.conf);
  
  hold off
  axis([min(x),x_lim, min(y) y_lim]);
  axis equal  
  title(evalGenerateFilename(params), ...
    'Color',[0 0 0], ...
    'interpreter', 'none');
  xlabel('x-coordinate of Head Position');
  ylabel('y-coordinate of Head Position');
end
end
