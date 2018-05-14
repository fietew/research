function [P, p] = bsRotatePWD(P, phi)
% Rotates the PWD about a specified angle
%
%   Usage: [P, p] = bsRotatePWD(P, phi)
%
%   Input parameters:
%       P           - PWD in frequency domain
%       phi         - shift angle (rounded to fit angular grid of the PWD)
%
%   Output parameters:
%       irs         - directional HRIRs for phi=[-180:360/pi:180). Contains
%                     .right and .left (each [Nhrir x Npw])
%
%   bsRotatePWD(P, phi) shifts the PWD about the specified angle phi
%   rounded to angular grid of the PWD. This can be used to generate the
%   wavefield of a rotated source.
%
%   see also: bsShiftPWD

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

Nf = size(P,1);  % Number of frequency samples
Npw = size(P,2);  % Number of angular samples
shift = round(phi/(2*pi)*Npw);  % compute angular shift (rounding)

P = circshift(P,[0 shift]);  % shift PWD

p = ifft(cat(1,P,zeros(Nf-2,Npw)),[],1,'symmetric');  % get time-PWD
