publications
============

This is repository for additional material and figures of my publications.

List of Publications
--------------------

BibTeX file for all publications can be at [here](papers/papers.bib)

[A. Winter, F. Schultz, S. Spors. Localization Properties of Data-based Binaural Synthesis including Translatory Head-Movements. FORUM ACUSTICUM, 2014.](papers/2014-09_ForumAcusticum_Localization Binaural Synthesis)

Usage
-----

The material for specific publications is stored under the papers directory. In
order to generate a figure of one of the publications, switch to the figXX
directory and execute the scripts in the following order (if existent):

1. MATLAB script: fixXX.m
2. gnuplot script: figXX.gnu
3. include figXX.tex, figXX.png, figXX.pdf in your LaTeX document

Requirements
------------

### LaTeX

* Tikz
* PGF-plots

### MATLAB

The code of this repository has been tested under MATLABR2013b. It uses the
following toolboxes, which you should download and add the their path to your
MATLAB path. For specific installation instructions please take a look at the
listed websites.
* Auditory Modelling Toolbox ( http://amtoolbox.sourceforge.net/ )
* LTFAT Toolbox( http://sourceforge.net/projects/ltfat/ )
* SOFIA Toolbox ( https://code.google.com/p/sofia-toolbox/ )
* MATLAB2TIKZ ( https://github.com/nschloe/matlab2tikz )

Please also add the `./tools/matlab` directory to your MATLAB path.
