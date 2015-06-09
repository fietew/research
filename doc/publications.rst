.. ****************************************************************************
 * Copyright (c) 2015      Fiete Winter                                       *
 *                         Institut fuer Nachrichtentechnik                   *
 *                         Universitaet Rostock                               *
 *                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
 *                                                                            *
 * This file is part of the supplementary material for Fiete Winter's         *
 * scientific work and publications                                           *
 *                                                                            *
 * You can redistribute the material and/or modify it  under the terms of the *
 * GNU  General  Public  License as published by the Free Software Foundation *
 * , either version 3 of the License,  or (at your option) any later version. *
 *                                                                            *
 * This Material is distributed in the hope that it will be useful, but       *
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
 * or FITNESS FOR A PARTICULAR PURPOSE.                                       *
 * See the GNU General Public License for more details.                       *
 *                                                                            *
 * You should  have received a copy of the GNU General Public License along   *
 * with this program. If not, see <http://www.gnu.org/licenses/>.             *
 *                                                                            *
 * http://github.com/fietew/publications           fiete.winter@uni-rostock.de*
 ******************************************************************************

Material
========

List of Publications
--------------------

.. bibliography:: ../papers/papers.bib
  :style: alpha
  :all:

Requirements
------------

Gnuplot
~~~~~~~

LaTeX
~~~~~

* TikZ
* PGF-plots

MATLAB
~~~~~~

The code of this repository has been tested under MATLABR2013b. Please add
the ``./tools/matlab`` directory to your MATLAB path. The software uses the
following toolboxes, which you should download and add the their path to your
MATLAB path. For specific installation instructions please take a look at the
listed websites.

* `Auditory Modelling Toolbox (AMT) <http://amtoolbox.sourceforge.net/>`_
* `The Large Time/Frequency Analysis Toolbox (LTFAT) <http://sourceforge.net/projects/ltfat/>`_
* `Sound Field Analysis Toolbox (SOFiA) <https://code.google.com/p/sofia-toolbox/>`_
* `Sound Field Synthesis Toolbox (SFS) <https://github.com/sfstoolbox/sfs/>`_
* `MATLAB2TikZ <https://github.com/nschloe/matlab2tikz/>`_
* `EKF/UKF Toolbox <https://github.com/fietew/ekfukf/>`_

If you just want to get the material of one specific publication, you may
not need all the toolboxes. The table shows, which publication needs which
toolbox.

============================  =====  ======= ======= ===== ========== =========
 Publication                   AMT    LTFAT   SOFiA   SFS   MAT2TikZ   EKF/UKF
============================  =====  ======= ======= ===== ========== =========
:cite:`Winter2014-FA`           X       X       X      X        X
:cite:`Winter2015-DAGA`                                X
:cite:`Winter2015-AES`          X                      X        X
:cite:`Winter2015-EuroNoise`    X                      X        X
============================  =====  ======= ======= ===== ========== =========

How to reproduce Figures
------------------------

The material for a specific publications is stored under the ``papers``
directory. In order to generate a figure of one of the publications, switch to
the figXX directory and execute the scripts in the following order
(if existent):

1. MATLAB script: fixXX.m
2. gnuplot script: figXX.gnu
3. include figXX.tex, figXX.png, figXX.pdf in your LaTeX document
