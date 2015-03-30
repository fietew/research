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
%
%
%*****************************************************************************
% Copyright (c) 2015      Fiete Winter                                       *
%                         Institut fuer Nachrichtentechnik                   *
%                         Universitaet Rostock                               *
%                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
%                                                                            *
% This file is part of the supplementary material for Fiete Winter's         *
% scientific work and publications                                           *
%                                                                            *
% You can redistribute the material and/or modify it  under the terms of the *
% GNU  General  Public  License as published by the Free Software Foundation *
% , either version 3 of the License,  or (at your option) any later version. *
%                                                                            *
% This Material is distributed in the hope that it will be useful, but       *
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
% or FITNESS FOR A PARTICULAR PURPOSE.                                       *
% See the GNU General Public License for more details.                       *
%                                                                            *
% You should  have received a copy of the GNU General Public License along   *
% with this program. If not, see <http://www.gnu.org/licenses/>.             *
%                                                                            *
% http://github.com/fietew/publications           fiete.winter@uni-rostock.de*
%*****************************************************************************

% check for parallel computing toolbox
if license('test', 'distrib_computing_toolbox')
  parfor idx=1:size(param_values,1)
    tmp = assignfield_recursive(params, param_names, param_values(idx,:));
    func(tmp);
  end
else
  for idx=1:size(param_values,1)
    tmp = assignfield_recursive(params, param_names, param_values(idx,:));
    func(tmp);
  end
end

end
