function S = assignfield_recursive(S, fieldname, fieldvalue)
% Assigns values to nested fieldnames in struct
%
% input:
%   S           - a scalar structure
%   fieldname   - either ones single string or a cell array of strings with 
%                 the names of the fields (may contain dots defining sub-structures)
%   fieldvalue  - corresponding values to which the respective field is set.
%                 either one single value or a cell array of values
%
% output:
%   S           - a scalar structure with new values assigned to it
%
% Example:
%   test.blub.blub = 2;
%   test.blub.bla = 2;
%   assignfield_recursive(test,{'blub.bla', 'blub.blub'}, {1, 3})
%
%% ===== Check Input Arguments =================================================

% convert single string into cell array of that one string
if ~iscell(fieldname)
  fieldname = {fieldname};
end
% check if cell array of strings
if ~iscellstr(fieldname)
  error('%s: %s has to be a single string or a cell array of strings', ....
    upper(mfilename), inputname(2));
end
% test existence of (sub-)fields
test_existence = ~isfield_recursive(S, fieldname);
if any(test_existence)
  err_string = [];
  for idx=find(test_existence)
    err_string = sprintf('%s\n\t%s', err_string, fieldname{idx});
  end
  error('%s: The following fields do not exist in %s:%s', upper(mfilename), ...
    inputname(1), err_string);
end
% convert single value into cell array of that one value
if ~iscell(fieldvalue)
  fieldvalue = {fieldvalue};
end
% check sizes of fieldnames and fieldvalues
if any(size(fieldname) ~= size(fieldvalue))
  error('%s: Dimension mismatch between %s and %s!', upper(mfilename), ...
    inputname(2), inputname(3));
end

%% ===== Computation ===========================================================

for idx=1:numel(fieldname)
  % eval is necessary since the actual fieldname is unknown a-priori
  eval(sprintf('S.%s = fieldvalue{idx};', fieldname{idx}));
end
