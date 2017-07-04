function nfchoa_itd_ild( conf )
% ITD/ILD histogram from Binaural Impulse Responses convolved with a
% white noise. The Two!Ears Auditory Front End is required

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

%% ===== Computation ====================================================

% load impulse responses
prefix = brs_nameprefix(conf);
[irs, fs] = audioread(['brs_' prefix '.wav']);
% signal
rng(0);  % seed for random number generator
sig = randn(10*fs,1);  % 10 second stimulus
% convolution
sig = convolution(irs, sig);

% parameters for gammatone filterbank modelling human's frequency selectivity
afeSettings = genParStruct(...
    'fb_type', 'gammatone', ...
    'fb_lowFreqHz', 80, ...
    'fb_highFreqHz', 16000, ...
    'fb_nERBs', 1.0 ...
  );

% instantiation of data and manager objects
dataObj = dataObject(sig, fs);
managerObj = manager(dataObj, {'ild', 'itd', 'ic'}, afeSettings);

% start processing
managerObj.processSignal();

% output of auditory frontend
ild = dataObj.ild{1}.Data(:);  % ild (linear)
itd = dataObj.itd{1}.Data(:)*1000;  % itd in milliseconds
ic = dataObj.ic{1}.Data(:);  % interaural coherence [0..1]
fc = dataObj.ild{1}.cfHz;  % centre frequencies of filters in Hz
nBlocks = size(ild,1);  % number of ITD/ILD estimates

% === ITD histogram ===
itd_bins_center = -2:0.05:2;  % centers of itd bins
% edges of ild bins
itd_bins_edges = [-inf, ...
    0.5*itd_bins_center(1:end-1) + 0.5*itd_bins_center(2:end), inf];
% contains index of bin for each element in itd
[~,hdx] = histc(itd, itd_bins_edges, 1);  % histogram along signal blocks

hist_itd_ic = zeros(length(itd_bins_center), length(fc));
% iterate over all gammatone channels
for fdx = 1:length(fc)
  % iterate over all bins
  for idx = 1:length(itd_bins_center)
    % sum all IC-values which belong to an ITD value in the current bin
    hist_itd_ic(idx, fdx) = sum(ic(hdx(:,fdx) == idx, fdx));
  end
end
hist_itd_ic = hist_itd_ic./nBlocks;  % normalize histogram

% === ILD histogram ===
ild_bins_center = -40:1:40;  % centers of ild bins
% edges of ild bins
ild_bins_edges = [-inf, ... 
    0.5*ild_bins_center(1:end-1) + 0.5*ild_bins_center(2:end), inf];
% contains index of bin for each element in ild
[~,hdx] = histc(ild, ild_bins_edges, 1);  % histogram along signal blocks

hist_ild_ic = zeros(length(ild_bins_center), length(fc));
% iterate over all gammatone channels
for fdx = 1:length(fc)
   % iterate over all bins
  for idx = 1:length(ild_bins_center)
    % sum all IC-values which belong to an ILD value in the current bin
    hist_ild_ic(idx, fdx) = sum(ic(hdx(:,fdx) == idx, fdx));
  end
end
hist_ild_ic = hist_ild_ic./nBlocks;  % normalize histogram

%% ===== Gnuplot ========================================================

gp_save(['hist_itd_ic_' prefix '.txt'], [itd_bins_center(:), hist_itd_ic]);
gp_save(['hist_ild_ic_' prefix '.txt'], [ild_bins_center(:), hist_ild_ic]);
gp_save('fc.txt', fc(:));
