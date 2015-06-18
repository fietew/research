function evalExhaustive(param_names, param_values, params)

if length(param_names) ~= size(param_values,2)
  error('number of colums of param_values has to match length of param_names');
end

for kdx=1:length(param_names)
  name = param_names{kdx};
  dots = find(name == '.');
  if isempty(dots)
    if ~isfield(params, name) 
      error('all "param_names" must be fields of the "params" struct!');
    end
  elseif ~isfield(params, name(1:dots-1)) ...
    || ~isfield(params.(name(1:dots-1)), name(dots+1:end)) 
    error('all "param_names" must be fields of the "params" struct!');
  end
end

for idx=1:size(param_values,1)
  
  % assign next parameter set to "params"
  for kdx=1:size(param_values,2)
    name = param_names{kdx};
    dots = find(name == '.');
    if isempty(dots)    
      params.(name) = param_values{idx, kdx};
    else
      params.(name(1:dots-1)).(name(dots+1:end)) = ...
        param_values{idx, kdx};
    end
  end
  
  % filename
  filename = evalGenerateFilename(params);
  
  % compute plane wave decomposition
  [P, ~, kpw, ~, ~] = bsPlaneWaveDecomposition(params.source, params);
  
  % save pwd to mat-file  
  save(fullfile(params.files.basepath, 'pwds', [filename, '.mat']), ...
    'params', ...
    'P', '-v7.3');
  
  % adapt angular resolution
  P = bsAngularResolution(P, kpw, 360/params.Npw);
  
  % evaluate Localization
  out = evalLocalization(P, params);
  
  % save results to mat file
  save(fullfile(params.files.basepath, 'results', [filename,'.mat']), ...
    'params', ...
    'out', '-v7.3');
  
  % save results to txt file (gnuplot)
  M = eye(3);
  tmp_params = params;
  for jdx=1:length(params.rot)
    rot = params.rot(jdx);
    M(1:2,1:2) = [cosd(rot), -sind(rot); sind(rot), cosd(rot)];
    tmp_params.source.position = params.source.position*M.';
    filename = evalGenerateFilename(tmp_params);
    gp_save(fullfile(params.files.basepath, 'results', [filename,'.txt']), ...
      [params.shift(:,1:2),out.phi(:,jdx),out.delta(:,jdx)]);
  end  
end