function S = assignfield_recursive(S, fieldname, fieldvalue)
% Recursively determines whether the input is a field of the structure
%
% input:
%   S           - a scalar structure
%   fieldname   - either a string or a cell array of strings with the names
%                 of the fields (may contain dots defining sub-structures)
%
% output:
%   S           - a scalar structure with new values assigned to it
%
% Example:
%   test.blub.blub = 2;
%   test.blub.bla = 2;
%   assignfield_recursive(test,{'blub.bla', 'blub.blub'}, {1, 3})

if ~iscell(fieldname)
  fieldname = {fieldname};
end  
if ~iscellstr(fieldname)
  error('fieldname has to contain string(s)');
end
test_existence = ~isfield_recursive(S, fieldname);
if any(test_existence)
  fprintf('Regarding the fieldnames:\n');
  for idx=find(test_existence)
    fprintf('%s\n', fieldname{idx});
  end
  error('These fields do not exist in %s!', inputname(1));
end

if ~iscell(fieldvalue)
  fieldvalue = {fieldvalue};
end
if any(size(fieldname) ~= size(fieldvalue))
  error('Dimension mismatch between %s and %s', inputname(2), inputname(3));
end

for idx=1:numel(fieldname)
  dots = find(fieldname{idx} == '.');  % find dots in fieldname

  if isempty(dots)
    % is there is no dot in the fieldname anymore the recursion terminates and 
    % one can assign the value to the structure field
    S.(fieldname{idx}) = fieldvalue{idx};
  else
    S.(fieldname{idx}(1:dots(1)-1)) = assignfield_recursive(...
      S.(fieldname{idx}(1:dots(1)-1)), ...
      fieldname{idx}(dots(1)+1:end), ...
      fieldvalue{idx});
  end
end

end