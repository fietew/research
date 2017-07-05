#!/usr/bin/gnuplot

# helper script to plot magnitude spectrum of reproduced plane wave

#*****************************************************************************
# Copyright (c) 2015      Fiete Winter                                       *
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

plot 'data.txt' u ($1/1000):(column(1+ps_wfs*Npos+pos) - column(1+ps_gt*Npos+pos)) w l ls 7 lw 4, \
     'data.txt' u ($1/1000):(column(1+ps_lsfs*Npos+pos) - column(1+ps_gt*Npos+pos)) w l ls 2 lw 3,\

