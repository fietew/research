function res = eval_sfs_imp(conf)
% time domain driving signals of various (L)SFS techniques

%*****************************************************************************
% Copyright (c) 2017      Fiete Winter                                       *
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
src = conf.src;
method = conf.method;
xeval = conf.xeval;
N = conf.N;
fs = conf.fs;

% config for simulation of sound propagation
highconf = conf;
highconf.delayline.resampling = 'pm';
highconf.delayline.resamplingfactor = 8;
highconf.delayline.resamplingorder = 64;
highconf.delayline.filter = 'lagrange';
highconf.delayline.filterorder = 9;

%% ===== Computation ==========================================================
% Get secondary sources
x0 = secondary_source_positions(conf);

% Get driving signals
switch method
  case 'gt'
    pulse = dirac_imp;
    d = [pulse; zeros(N-length(pulse),1)];    
    switch src
      case 'ps'
        x0 = [xs, 0, -1, 0, 1];
        delay_offset = 0;
      case 'pw'
        x0 = [-xs*3.0, xs, 1];
        d = d*4*pi*norm(x0(:,1:3)-xeval);
        delay_offset = 0;
    end
  case 'nfchoa'
    [d, ~, delay_offset] = driving_function_imp_nfchoa(x0, xs, src, conf);
  case 'wfs'
    x0 = secondary_source_selection(x0, xs, src);
    x0 = secondary_source_tapering(x0, conf);    
    [d, ~, ~, delay_offset] = driving_function_imp_wfs(x0, xs, src, conf);
  case 'lwfs-sbl'
    [d, delay_offset] = driving_function_imp_localwfs_sbl(x0,xs,src,conf);
    
    % WORKAROUND to remove transient compensation again 
    if ~conf.localsfs.sbl.useap        
        % Ambisonics order
        if isempty(conf.localsfs.sbl.order)
            N0 = size(x0,1);
            Nce = nfchoa_order(N0,conf);
        else
            Nce = conf.localsfs.sbl.order;
        end
        % Crossover frequency
        if isempty(conf.localsfs.sbl.fc)
            fc = aliasing_frequency(conf);
        else
            fc = conf.localsfs.sbl.fc;  
        end
        Nlr = ceil(Nce/2)*2;  % order of Linkwitz-Riley Coefficients
        Wlr = fc/fs*2;  % normalised cut-off frequency of Linkwitz-Riley
        % coefficients for allpass filtering
        [zap,pap,kap] = linkwitz_riley(Nlr,Wlr,'all');
        [sos,g] = zp2sos(zap,pap,kap,'down','none');  % generate sos
        % (time-reversed) allpass filtering
        d = sosfilt(sos,d)*g;
    end
  otherwise
    error('unknown method: %s', method);
end
% spectrum of driving signals
for idx=1:size(d,2);
  [D(:,idx), Dphase(:,idx), f] = spectrum_from_signal(d(:,idx), conf);
end

% impulse response and spectrum of sound field at xt
p = ir_generic(xeval, 0, x0, d, dummy_irs(2048, highconf), highconf);
conf.plot.useplot = conf.useplot;
[P, Pphase] = spectrum_from_signal(p(:,1), conf);
if conf.useplot
  title(evalGenerateFilename(conf), 'Interpreter', 'None');
end

%% ===== Save File =======================================================
res.conf = conf;
res.x0 = x0;
res.d = d;
res.D = D.*exp(1j*Dphase);
res.delay_offset = delay_offset;
res.f = f;
res.name = evalGenerateFilename(conf);
res.p = p(:,1);
res.P = P.*exp(1j*Pphase);

save([res.name, '.mat'], 'res');

end