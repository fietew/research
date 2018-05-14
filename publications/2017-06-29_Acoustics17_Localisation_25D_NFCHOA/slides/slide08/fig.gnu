#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2013-2018 Fiete Winter                                       *
#                         Institut fuer Nachrichtentechnik                   *
#                         Universitaet Rostock                               *
#                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
#                                                                            *
# This file is part of the supplementary material for Fiete Winter's         *
# scientific work and publications                                           *
#                                                                            *
# You can redistribute the material and/or modify it  under the terms of the *
# GNU  General  Public  License as published by the Free Software Foundation *
# , either version 3 of the License,  or (at your option) any later version. *
#                                                                            *
# This Material is distributed in the hope that it will be useful, but       *
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
# or FITNESS FOR A PARTICULAR PURPOSE.                                       *
# See the GNU General Public License for more details.                       *
#                                                                            *
# You should  have received a copy of the GNU General Public License along   *
# with this program. If not, see <http://www.gnu.org/licenses/>.             *
#                                                                            *
# http://github.com/fietew/publications           fiete.winter@uni-rostock.de*
#*****************************************************************************

set loadpath './../../gnuplot'

load 'common.gnu'

################################################################################
set multiplot layout 2,2

set loadpath './../../gnuplot' '../../../../tools/gnuplot/'

@top
@lef
set label 2 '\ft no bandlimitation'
# palette
load 'sequential/Blues.plt'
# plotting
datafile = 'posx-1.00_posy0.00_ref'
load 'hist.gnu'

@rig
set label 2 '\ft $M=13$, rect'
# palette
load 'sequential/Reds.plt'
# plotting
datafile = 'posx-1.00_posy0.00_pw_wo13_wrect'
load 'hist.gnu'

@bot
@lef
set label 2 '\ft $M=13$, max-$r_E$'
# palette
load 'sequential/Greens.plt'
# plotting
datafile = 'posx-1.00_posy0.00_pw_wo13_wmax-rE'
load 'hist.gnu'

@rig
set label 2 '\ft $M=27$, max-$r_E$'
# plotting
datafile = 'posx-1.00_posy0.00_pw_wo27_wmax-rE'
load 'hist.gnu'

################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'

# vim: set textwidth=200:
