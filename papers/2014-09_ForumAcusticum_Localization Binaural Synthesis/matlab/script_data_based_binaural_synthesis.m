% Script for Localization Properties of Data-based Binaural Synthesis
% 
% F.Winter, F.Schultz, S.Spors

clear all;

%% Parameters
script_parameters;  % all the parameters

xT = [0.5, -0.3, 0.0];  % shift vector
phi_rot = pi/4;  % rotation angle

%% Prerequisites
hrirs = read_irs(params.files.hrirs,params.conf);  % read irs

% generate Lookup-Table for Localization (SFS-Toolbox)
% lookup = itd2anglelookuptable(hrirs, params.conf.fs, params.model.name);
% save(params.files.lookup, 'lookup');

%% Plane Wave Decomposition of specified Wavefield
[P, p, kpw, fpw, tpw] = bsPlaneWaveDecomposition(params.source, params);

%% Apply Shift/Rotation/Subsampling and auralization
% shift of plane wave decomposition
[P_shift, p_shift, tau] = bsShiftPWD(P, fpw, kpw, xT, params);

% rotate plane wave decomposition
[P_rot, p_rot] = bsRotatePWD(P, phi_rot);

% subsample plane wave decomposition
[P_sub, kpw_sub] = bsAngularResolution(P, kpw, 2);
p_sub = bsAngularResolution(p, kpw, 2);

% open HRTF-Dataset
hrirs_pw = read_irs(params.files.hrirs, params.conf);

% auralization of original pwd
[bir, tbir] = bsAuralizePWD(p, tpw, hrirs_pw, params);
ir.left = sum(bir.left,2);
ir.right = sum(bir.right,2);

% auralization of shifted pwd
[bir_shift, tbir_shift] = bsAuralizePWD(p_shift, tpw, hrirs_pw, params);
ir_shift.left = sum(bir_shift.left,2);
ir_shift.right = sum(bir_shift.right,2);

% auralization of rotated pwd
[bir_rot, tbir_rot] = bsAuralizePWD(p_rot, tpw, hrirs_pw, params);
ir_rot.left = sum(bir_rot.left,2);
ir_rot.right = sum(bir_rot.right,2);

% auralization of sub-sampled pwd
[bir_sub, tbir_sub] = bsAuralizePWD(p_sub, tpw, hrirs_pw, params);
ir_sub.left = sum(bir_sub.left,2);
ir_sub.right = sum(bir_sub.right,2);


%% Auralize input data
input = localization_noise();  % some input signal for localization
%input = repmat(input,20,1);

%input = audioread('tools/kastagnetten.wav');

output = [];
output(:,1) = conv(ir.left, input);
output(:,2) = conv(ir.right, input);

output_shift = [];
output_shift(:,1) = conv(ir_shift.left, input);
output_shift(:,2) = conv(ir_shift.right, input);

output_rot = [];
output_rot(:,1) = conv(ir_rot.left, input);
output_rot(:,2) = conv(ir_rot.right, input);

output_sub = [];
output_sub(:,1) = conv(ir_sub.left, input);
output_sub(:,2) = conv(ir_sub.right, input);

%% Localization with binaural model
load(params.files.lookup, 'lookup');

phi_real = atan2d(params.source.position(2), params.source.position(1));
phi_rot_real = phi_real + rad2deg(phi_rot);
phi_sub_real = phi_real;
switch params.source.type
  case 'point'
    r_shift = params.source.position - xT;
    phi_shift_real = atan2d(r_shift(2), r_shift(1));
  otherwise   
    phi_shift_real = phi_real;
end

[phi, itd, ild] = ...
  wierstorf2013estimateazimuth(output,lookup);
[phi_shift, itd_shift, ild_shift]  = ...
  wierstorf2013estimateazimuth(output_shift,lookup);
[phi_rot, itd_rot, ild_rot]  = ...
  wierstorf2013estimateazimuth(output_rot,lookup);
[phi_sub, itd_sub, ild_sub]  = ...
  wierstorf2013estimateazimuth(output_sub,lookup);

disp(phi);
disp(phi_real);
disp(phi_shift);
disp(phi_shift_real);
disp(phi_rot);
disp(phi_rot_real);
disp(phi_sub);
disp(phi_sub_real);

%% play output
fprintf('Put on your Headphones, press button to continue');
fprintf('\n');
pause;
fprintf('Original anechoic signal, press button to continue');
fprintf('\n');
soundsc(input,params.conf.fs);
pause;
fprintf('Auralized signal, press button to continue');
fprintf('\n');
soundsc(output,params.conf.fs);
pause;
fprintf('Auralized shifted signal, press button to continue');
fprintf('\n');
soundsc(output_shift,params.conf.fs);
pause;
fprintf('Auralized rotated Signal, press button to continue');
fprintf('\n');
soundsc(output_rot,params.conf.fs);
pause;
fprintf('Auralized subsampled Signal');
fprintf('\n');
soundsc(output_sub,params.conf.fs);

%% plotting
close all;
% pwd
bsPlotPWD(P, p, kpw, fpw, tpw);
% shifted pwd
bsPlotPWD(P_shift, p_shift, kpw, fpw, tpw);
% rotate pwd
bsPlotPWD(P_rot, p_rot, kpw, fpw, tpw);
% subsample pwd
bsPlotPWD(P_sub, p_sub, kpw_sub, fpw, tpw);
% hrirs
bsPlotBIR(hrirs_pw, kpw);
% hrirs * pwd
bsPlotBIR(bir, kpw, tbir);
% hrirs * shifted pwd
bsPlotBIR(bir_shift, kpw, tbir_shift);
% hrirs * rot pwd
bsPlotBIR(bir_rot, kpw, tbir_rot);
% hrirs * subsampled pwd
bsPlotBIR(bir_sub, kpw_sub, tbir_sub);
%
bsPlotBIR(ir, [], tbir_shift);
%
bsPlotBIR(ir_shift, [], tbir_shift);
%
bsPlotBIR(ir_rot, [], tbir_rot);
%
bsPlotBIR(ir_sub, [], tbir_rot);