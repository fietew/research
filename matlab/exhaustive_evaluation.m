function res = exhaustive_evaluation(func, param_names, param_values, params, parallel)
%
% inputs:
%   func         - function expecting 'params' as the only input argument, 
%                  function handle [1x1]
%   param_names  - name of parameters which shall be iterated over, cell [1xN]
%   param_values - different value tuples for the parameters, cell [MxN]
%   params       - scalar structure containing all parameters
%   parallel     - if the distributed computing toolbox is available
%                  different tuples are processed in parallel (default: true)
%
% outputs:
%   res          - optional cell array which each cell containing the return
%                  value of the function specified by func. Note that the
%                  function HAS to provide a return value.
%
% example:
%   f = @(x) display(x);
%   
%   params.blub = 0;
%   params.test = 2;
%   params.bla = inf;
%
%   param_names = {'blub', 'test'}
%   param_values = {2, 'hello world'; 'hihi', pi}
%
%   res = exhaustive_evaluation(func, param_names, param_values, params)

if nargin < 5
  parallel = true;
end

if nargout == 1
  res = cell(size(param_values,1),1);
  ret = true;
end

% check for parallel computing toolbox
if license('test', 'distrib_computing_toolbox') && parallel
  parfor idx=1:size(param_values,1)
    tmp = assignfield_recursive(params, param_names, param_values(idx,:));
    if ret
      res{idx} = func(tmp);
    else
      func(tmp);
    end
  end
else
  for idx=1:size(param_values,1)
    tmp = assignfield_recursive(params, param_names, param_values(idx,:));
    if ret
      res{idx} = func(tmp);
    else
      func(tmp);
    end
  end
end

end