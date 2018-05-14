#!/usr/bin/gnuplot

# gnuplot script to plot ITD/ILD histograms
#
# Usage: datafile='some_datafile_prefix'
#        load 'hist.gnu'

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

# variables
amplitude_scale = 10

###### ILD histogram plots ######
# plotting
plot for [ii=ild_idx_max:ild_idx_min:-1] \
    'hist_ild_ic_'.datafile.'.txt' u 1:(amplitude_scale*(column(ii+1))+ii) axes x2y1 w filledcu above ls 8 ,\

set multiplot previous # workaround to select different palettes

###### ITD histogram plots ######
# plotting
plot for [ii=itd_idx_max:itd_idx_min:-1] \
    'hist_itd_ic_'.datafile.'.txt' u 1:(amplitude_scale*(column(ii+1))+ii) w filledcu above ls 5,\
