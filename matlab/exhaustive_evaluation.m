function exhaustive_evaluation(func, param_names, param_values, params)
%
% inputs:
%   func         - function expecting 'params' as the only input argument, 
%                  function handle [1x1]
%   param_names  - name of parameters which shall be iterated over, cell [1xN]
%   param_values - different value tuples for the parameters, cell [MxN]
%   params       - scalar structure containing all parameters
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
%   exhaustive_evaluation(func, param_names, param_values, params)

for idx=1:size(param_values,1)
  params = assignfield_recursive(params, param_names, param_values(idx,:));
  func(params);
end

end