function eval_gnuplot_soundfield(conf)
% reads file generated by lwfs_ir.m and appends the spectrum to a gnuplot
% readible txt file

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

%% ===== Configuration ========================================================
xs = conf.xs;
xeval = conf.xeval;
src = conf.src;
method = conf.method;
useplot = conf.useplot;
c = conf.c;

%% ===== Computation ==========================================================
load([conf.directory, evalGenerateFilename(conf), '.mat'], 'res');

X = [-1.6, 1.6];
Y = [-1.6, 1.6];
Z = 0;

switch conf.src
  case 'pw'
    t = xs*xeval.'/c;
    g = 1;
    front = bsxfun(@plus, xeval(1:2), linspace(-3,3,100).'*[-xs(2),xs(1)]);
  case 'ps'
    r = norm(xs - xeval);
    t = r/c;
    g = 1/(4*pi*r);
    phi = (0:100).'/100*2*pi;
    front = bsxfun(@plus, xs(1:2), r*[cos(phi),sin(phi)]);
end
t = t + res.delay_offset;

if ~strcmp(method, 'gt')
  src = 'ps';
end

conf.plot.useplot = useplot;
[P,x,y] = sound_field_imp(X,Y,Z,res.x0, src, res.d./g, t, conf);
if useplot
  title(evalGenerateFilename(conf), 'Interpreter', 'none');
end

gp_save_matrix([evalGenerateFilename(conf) '.dat'], x, y, db(P));
gp_save_loudspeakers([evalGenerateFilename(conf) '_ls.txt'], res.x0);
gp_save([evalGenerateFilename(conf) '_xeval.txt'], xeval);
gp_save([evalGenerateFilename(conf) '_front.txt'], front);

end