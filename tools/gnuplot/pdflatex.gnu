# Call this script together with a file base name to run pdflatex on it

#*****************************************************************************
# Copyright (c) 2012      Hagen Wierstorf                                    *
#                         Centre for Vision, Speech and Signal Processing    *
#                         University of Surrey                               *
#                         Guildford, GU2 7XH, UK                             *
#                                                                            *
# This file is part of the supplementary material for Hagen Wierstorf's      *
# phd-thesis                                                                 *
#                                                                            *
# Licensed under the Apache License, Version 2.0 (the "License"); you may    *
# not use this file except in compliance with the License. Y ou may obtain a *
# copy of the License at                                                     *
#                                                                            *
#   http://www.apache.org/licenses/LICENSE-2.0                               *
#                                                                            *
# Unless required by applicable law or agreed to in writing, software        *
# distributed  under the License is distributed on an "AS IS" BASIS, WITHOUT *
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the   *
# License for the specific language governing permissions and limitations    *
# under the License.                                                         *
#                                                                            *
# https://github.com/hagenw/phd-thesis                       hagenw@posteo.de*
#*****************************************************************************

unset output
!pdflatex @ARG1.tex
if (ARG2==2) { !pdflatex @ARG1.tex } # run LaTeX two times if requested
!rm @ARG1.tex \
    @ARG1.aux \
    @ARG1-inc.eps \
    @ARG1-inc-eps-converted-to.pdf \
    @ARG1.log \
    @ARG1.out
