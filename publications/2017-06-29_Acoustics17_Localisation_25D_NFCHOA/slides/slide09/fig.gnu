#!/usr/bin/gnuplot

#*****************************************************************************
# Copyright (c) 2013-2019 Fiete Winter                                       *
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

set loadpath '../../gnuplot/'

load 'common.gnu'

################################################################################
set multiplot layout 2,2

set loadpath '../../gnuplot/' '../../../../tools/gnuplot/'

# palette
load 'sequential/Greens.plt'

@top
@lef
set label 2 '\ft $(0,0,0)$ m'
datafile = 'posx0.00_posy0.00_pw_wo27_wmax-rE'
load 'hist.gnu'

@rig
set label 2 '\ft $(-0.33,0,0)$ m'
datafile = 'posx-0.33_posy0.00_pw_wo27_wmax-rE'
load 'hist.gnu'

@bot
@lef
set label 2 '\ft $(-0.66,0,0)$ m'
datafile = 'posx-0.66_posy0.00_pw_wo27_wmax-rE'
load 'hist.gnu'

@rig
set label 2 '\ft $(-1,0,0)$ m'
datafile = 'posx-1.00_posy0.00_pw_wo27_wmax-rE'
load 'hist.gnu'


################################################################################
unset multiplot

set output # Closes the temporary output files.
!sed 's|includegraphics{tmp}|includegraphics{fig}|' < tmp.tex > fig.tex
!epstopdf tmp.eps --outfile='fig.pdf'

# vim: set textwidth=200:
