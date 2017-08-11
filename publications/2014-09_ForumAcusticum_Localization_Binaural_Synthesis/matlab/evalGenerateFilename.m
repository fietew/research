function [ filename ] = evalGenerateFilename(params)

phi = atan2d(params.source.position(2), params.source.position(1));
r = norm(params.source.position);

filename = num2str(params.source.type);
if ~strcmp(params.source.type,'uniform')
  filename = [filename, '',  num2str(phi,'%1.1f')];
  if strcmp(params.source.type,'point')
    filename = [filename, ':',  num2str(r,'%1.1f')];
  end
  filename = [filename, '_',  params.beamformer];
  filename = [filename, '_NSHT', num2str(params.Nsht)];
  if strcmp(params.sampling.mode,'discrete')
    filename = [filename, '_', params.sampling.pattern];
    filename = [filename, '', num2str(params.sampling.Npoints)];
  else
    filename = [filename, '_', params.sampling.mode];
  end
  if strcmp(params.source.type,'point')
    filename = [filename, '_db', num2str(params.dblimit,'%1.1f')];
  end
end
filename = [filename, '_R', num2str(params.R)];
filename = [filename, '_NPW', num2str(params.Npw)];
end
