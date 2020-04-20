function G = circarc_piston_mono(x,y,z,xs,f,ThetaC,conf)
%CIRCARC_PISTON_MODEL hf-approximated circular piston radiator model
%
%   Usage: G = circarc_piston_mono(x,y,z,xs,f,ThetaC,conf)
%
%   Input options:
%       x,y,z   - x,y,z points for which the Green's function should be
%                 calculated / m
%       xs      - position of the source
%       f       - frequency of the source / Hz
%       ThetaC  - opening of circular arc / rad
%       conf    - configuration struct (see SFS_config)
%
%   Output parameters:
%       G       - Green's function evaluated at the points x,y,z
%
%   See also: sound_field_mono

%*****************************************************************************
% The MIT License (MIT)                                                      *
%                                                                            *
% Copyright (c) 2010-2019 SFS Toolbox Developers                             *
%                                                                            *
% Permission is hereby granted,  free of charge,  to any person  obtaining a *
% copy of this software and associated documentation files (the "Software"), *
% to deal in the Software without  restriction, including without limitation *
% the rights  to use, copy, modify, merge,  publish, distribute, sublicense, *
% and/or  sell copies of  the Software,  and to permit  persons to whom  the *
% Software is furnished to do so, subject to the following conditions:       *
%                                                                            *
% The above copyright notice and this permission notice shall be included in *
% all copies or substantial portions of the Software.                        *
%                                                                            *
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *
% IMPLIED, INCLUDING BUT  NOT LIMITED TO THE  WARRANTIES OF MERCHANTABILITY, *
% FITNESS  FOR A PARTICULAR  PURPOSE AND  NONINFRINGEMENT. IN NO EVENT SHALL *
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
% LIABILITY, WHETHER  IN AN  ACTION OF CONTRACT, TORT  OR OTHERWISE, ARISING *
% FROM,  OUT OF  OR IN  CONNECTION  WITH THE  SOFTWARE OR  THE USE  OR OTHER *
% DEALINGS IN THE SOFTWARE.                                                  *
%                                                                            *
% The SFS Toolbox  allows to simulate and  investigate sound field synthesis *
% methods like wave field synthesis or higher order ambisonics.              *
%                                                                            *
% https://sfs.readthedocs.io                            sfstoolbox@gmail.com *
%*****************************************************************************


%% ===== Checking of input  parameters ==================================
% Disabled checking for performance reasons


%% ===== Configuration ==================================================
c = conf.c;
phase = conf.phase;

%% ===== Computation =====================================================
% Frequency
f = f(:);
k = 2*pi*f./c;

% Source model: 3D Green's function + far-field directivity.
% 
%
%              1  e^(-i w/c |x-xs|)     
% G(x-xs,w) = --- ----------------- D(Theta, w)
%             4pi      |x-xs|       
%
% with cos(Theta) = ((x-xs)^T nxs)/|x-xs|

% r = |x-xs|
r = sqrt((x-xs(1)).^2+(y-xs(2)).^2+(z-xs(3)).^2);
%
G = exp(-1i*k.*r)./(4*pi*r);
% scalar = (x-xs)^T nxs
scalar = xs(4).*(x-xs(1)) + xs(5).*(y-xs(2))  + xs(6).*(z-xs(3));
% Angle between normal ns and (x - xs)
Theta = real(acos(scalar./r));

% Continuous Approximation of Unit Directitivy between +-ThetaC
Dir = 1./(1 + (Theta./ThetaC).^6);

% apply directivity
G = G.*Dir;

% Add phase to be able to simulate different time steps
G = G .* exp(-1i*phase);

end
