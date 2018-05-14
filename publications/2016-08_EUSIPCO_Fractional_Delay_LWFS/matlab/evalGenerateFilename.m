function [ filename ] = evalGenerateFilename(conf)

%*****************************************************************************
% Copyright (c) 2013-2018 Fiete Winter                                       *
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

% parametrisation of Local Wave Field Synthesis
r = norm(conf.localsfs.vss.center);
filename = sprintf('Rc%2.2f_Nl%d_N0%d', ...
  r, ...
  conf.localsfs.vss.number, ...
  conf.secondary_sources.number ...
  );

% 
filename = sprintf('%s_Fs%d_F%s', ...
  filename, ...
  conf.fs, ...
  conf.delayline.filter ...
  );

if ~strcmp( conf.delayline.filter, 'zoh' )
  filename = sprintf('%s_FOrder%d', ...
    filename, ...
    conf.delayline.filterorder ...
    );
end

if ~strcmp( conf.delayline.resampling, 'none')
  filename = sprintf('%s_R%s_Rfactor%d', filename, ...
    conf.delayline.resampling, conf.delayline.resamplingfactor);

  if strcmp( conf.delayline.resampling, 'pm' )
    filename = sprintf('%s_RFOrder%d', filename, ...
      conf.delayline.resamplingorder);
  end
end