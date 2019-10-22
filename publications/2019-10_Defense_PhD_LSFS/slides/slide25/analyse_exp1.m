%% parameters
% histogram bins
err_hist_bins = -20:2:20;  % bins for localisation error histogram
t_hist_bins = 0.5:1:35.5;  % bins for time-per-trial histogram

subjects = 1:12;
% significance level aka. (1 - confidence level)
alpha = 0.01;
% listening positions
x = [0.00; 0.50; 1.00; 0.00; 0.50; 1.00; 1.25;  0.00;  0.50;  1.00]*(-1);
y = [0.75; 0.75; 0.75; 0.00; 0.00; 0.00; 0.00; -0.75; -0.75; -0.75];
% source position
xs = 0;
ys = 2.5;
% ground truth of localisation angle
gt = repmat(atan2d(x-xs,ys-y),7,1);
% loudspeaker array
phi0 = (0:55)*360/56;
x0 = 1.5*cosd(phi0);
y0 = 1.5*sind(phi0);

vecscale = 0.5;

results_dir = 'exp1/';

filenames = {
    'exp1_NFCHOA_L56_R006'
    'exp1_NFCHOA_L56_R013'
    'exp1_NFCHOA_L56_R027'
    'exp1_NFCHOA_L56_R300'
    'exp1_NFCHOA_L56_M006'
    'exp1_NFCHOA_L56_M013'
    'exp1_NFCHOA_L56_M027'
};

%% parsing

filelist = dir([results_dir, '*_subject*_rating_main.csv']);
fdx = 0;

%files containing offsets
offset_angles = dlmread('exp1/localisation_offsets.csv');

loc = zeros(70,1,size(filelist,1));
offsets = loc;
calib = zeros(10,1,size(filelist,1));
gt_calib = calib;
for file = filelist.'
    fdx = fdx+1;

    %% localisation data
    % parse the file for localisation azimuths
    data = dlmread([results_dir, file.name],',',1,0);
    % id of subject
    subid = data(1,1);
    % select speaker condition for calibration (condition 1-10)
    select = data(:,3) <= 10;
    calib(:,1,fdx) = data(select, 10).*180./pi;
    gt_calib(:,1,fdx) = -offset_angles(subid+1,select).';
    % select everything but speakers (condition 10-80)
    select = data(:,3) > 10;
    data = data(select, :);  % localisation result
    offsets(:,1,fdx) = offset_angles(subid+1,select).';
    % sort data after condition ids
    [~,cdx] = sort(data(:,3));  
    loc(:,1,fdx) = data(cdx, 10).*180./pi;
    offsets(:,1,fdx) = offsets(cdx,1,fdx);
end   

%% data calibration
[loc_corrected, calib_corrected] = data_calibration(calib,gt_calib,loc);

%% corrected signed localisation error
err = loc_corrected + offsets - repmat(gt,1,size(loc,2),size(loc,3));

err_stats = statistics(err, alpha, err_hist_bins);

% MSEpos = mean(mean(abs(err).^2, 2), 3);
% RMSEpos = sqrt(reshape(MSEpos, 10, []));
% RMSEmethod = sqrt(mean(reshape(MSEpos, 10, []),1));
locerr = reshape(err_stats.mean_cond, 10, []);
locblur = sqrt(mean(reshape(err_stats.std_cond, 10, []).^2,1));
loc = reshape(gt, 10, []) + locerr;
ci = reshape(err_stats.mean_conf_cond, 10, []);

nu1 = (size(err,2).*size(err,3)-1).*10;

%% statistical testing
err_binaural = calib_corrected(:) - gt_calib(:);
blur_binaural = std(err_binaural);  % std of binaural synthesis
nu2 = length(err_binaural) - 1;


p_loc = [];
for idx=1:7
   tmp = err(1+(idx-1)*10:idx*10,:,:);
   [~,p_loc(idx)] = ttest2(tmp(:), err_binaural(:), 'Vartype', 'unequal');
end

p_blur = fcdf(locblur.^2./blur_binaural.^2,nu1,nu2,'upper');

% n = size(err,2).*size(err,3);
% [~, p_RMSEpos] = RMSEtest2(RMSEpos, sigma, n, length(err_binaural), alpha);
% 
% n = 10.*size(err,2).*size(err,3);
% [~, p_RMSEmethod] = RMSEtest2(RMSEmethod, sigma, n, length(err_binaural), alpha);

%% comparison of methods

% err_R006 = abs(err( 1:10,:,:));
% err_R013 = abs(err(11:20,:,:));
% err_R027 = abs(err(21:30,:,:));
% err_R300 = abs(err(31:40,:,:));
% err_M006 = abs(err(41:50,:,:));
% err_M013 = abs(err(51:60,:,:));
% err_M027 = abs(err(61:70,:,:));

err_R006 = (err( 1:10,:,:));
err_R013 = (err(11:20,:,:));
err_R027 = (err(21:30,:,:));
err_R300 = (err(31:40,:,:));
err_M006 = (err(41:50,:,:));
err_M013 = (err(51:60,:,:));
err_M027 = (err(61:70,:,:));

MDAE_NFCHOA_R006_M006 = err_R006 - err_M006;
MDAE_NFCHOA_R013_M013 = err_R013 - err_M013;
MDAE_NFCHOA_R027_M027 = err_R027 - err_M027;

MDAE_NFCHOA_R006_R013 = err_R006 - err_R013;
MDAE_NFCHOA_R013_R027 = err_R013 - err_R027;
MDAE_NFCHOA_R027_R300 = err_R027 - err_R300;

MDAE_NFCHOA_M006_M013 = err_M006 - err_M013;
MDAE_NFCHOA_M013_M027 = err_M013 - err_M027;

n = 10.*size(err,2).*size(err,3);
[~, p_MDAE_NFCHOA_R006_M006] = ttest(MDAE_NFCHOA_R006_M006(:))
[~, p_MDAE_NFCHOA_R013_M013] = ttest(MDAE_NFCHOA_R013_M013(:))
[~, p_MDAE_NFCHOA_R027_M027] = ttest(MDAE_NFCHOA_R027_M027(:))

[~, p_MDAE_NFCHOA_R006_R013] = ttest(MDAE_NFCHOA_R006_R013(:))
[~, p_MDAE_NFCHOA_R013_R027] = ttest(MDAE_NFCHOA_R013_R027(:))
[~, p_MDAE_NFCHOA_R027_R300] = ttest(MDAE_NFCHOA_R027_R300(:))

[~, p_MDAE_NFCHOA_M006_M013] = ttest(MDAE_NFCHOA_M006_M013(:))
[~, p_MDAE_NFCHOA_M013_M027] = ttest(MDAE_NFCHOA_M013_M027(:))

%% plotting

figure;
for idx=1:7
    subplot(3,3,idx);
    hold on;
    
    ciplot = [];
    for jdx=1:10
        r = vecscale.*0.75;
        phi = linspace(-ci(jdx,idx),ci(jdx,idx),360)+loc(jdx,idx)+90;
        
        xci = [0, cosd(phi)];
        yci = [0, sind(phi)];
        
        fill(x(jdx)+r.*xci,y(jdx)+r.*yci,'r');
        
        ciplot = [ciplot,x(jdx,ones(1,361)).',y(jdx,ones(1,361)).',xci.',yci.'];
    end
    
    errtmp = err((idx-1)*10+1:idx*10,:,:);
    
    gp_save([filenames{idx} '_corrected.txt'], reshape(errtmp,size(errtmp,1),[]));
    gp_save([filenames{idx} '_ci.txt'], ciplot);
    gp_save([filenames{idx} '_loc.txt'], [x,y, loc(:,idx), locerr(:,idx)]);
    gp_save([filenames{idx} '_avr.txt'], [mean(locerr(:,idx)), p_loc(idx), locblur(idx), p_blur(idx)]);
    
    quiver(x,y,vecscale.*cosd(loc(:,idx)+90),vecscale.*sind(loc(:,idx)+90), 0);
    plot(x0,y0,'ko');
    hold off;
    axis equal
end

%% save

gp_save('array.txt', [x0.',y0.']);
