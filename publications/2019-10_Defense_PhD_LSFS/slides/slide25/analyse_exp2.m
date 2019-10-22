%% parameters
% histogram bins
err_hist_bins = -20:2:20;  % bins for localisation error histogram
t_hist_bins = 0.5:1:35.5;  % bins for time-per-trial histogram

subjects = 1:20;
% significance level aka. (1 - confidence level)
alpha = 0.01;
% listening positions
x = [0.00; 0.50; 1.00; 0.00; 0.50; 1.00; 1.25;  0.00;  0.50;  1.00]*(-1);
y = [0.75; 0.75; 0.75; 0.00; 0.00; 0.00; 0.00; -0.75; -0.75; -0.75];
% source position
xs = 0;
ys = 2.5;
% ground truth of localisation angle
gt = repmat(atan2d(x-xs,ys-y),9,1);
% loudspeaker array
phi0 = (0:55)*360/56;
x0 = 1.5*cosd(phi0);
y0 = 1.5*sind(phi0);

vecscale = 0.5;

results_dir = 'exp2/';

filenames = {
    'exp2_WFS_L56'
    'exp2_NFCHOA_L56_R027'
    'exp2_LWFS-SBL_L56_R027'
    'exp2_LWFS-SBL_L56_M027'
    'exp2_LWFS-SBL_L56_R003'
    'exp2_LWFS-SBL_L56_M003'
    'exp2_LWFS-VSS_L56_r15'
    'exp2_LWFS-VSS_L56_r30'
    'exp2_LWFS-VSS_L56_r45'  
};

%% parsing

filelist = dir([results_dir, '*_subject*_rating_main.csv']);
fdx = 0;

loc = zeros(90,1,size(filelist,1));
offsets = loc;
calib = zeros(10,1,size(filelist,1));
gt_calib = calib;
for file = filelist.'
    fdx = fdx+1;
    % parse the file for localisation azimuths
    data = dlmread([results_dir, file.name],',',1,0);    
    % select speaker condition for calibration (condition == 1)
    select = data(:,3) == 1;
    calib(:,1,fdx) = data(select, 9).*180./pi;
    gt_calib(:,1,fdx) = -data(select, 5);
    % select everything but speakers (condition ~= 1)
    data = data(data(:,3) ~= 1, :);
    % sort data after condition id
    [~,cdx] = sort(data(:,3));
    % 
    loc(:,1,fdx) = data(cdx, 9).*180./pi;
    offsets(:,1,fdx) = data(cdx, 5);
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
for idx=1:9
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

% err_LWFSSBL_R027 = abs(err(21:30,:,:));
% err_LWFSSBL_M027 = abs(err(31:40,:,:));
% err_LWFSSBL_R003 = abs(err(41:50,:,:));
% err_LWFSSBL_M003 = abs(err(51:60,:,:));
% 
% err_LWFSVSS_r15  = abs(err(61:70,:,:));
% err_LWFSVSS_r30  = abs(err(71:80,:,:));
% err_LWFSVSS_r45  = abs(err(81:90,:,:));

err_LWFSSBL_R027 = (err(21:30,:,:));
err_LWFSSBL_M027 = (err(31:40,:,:));
err_LWFSSBL_R003 = (err(41:50,:,:));
err_LWFSSBL_M003 = (err(51:60,:,:));

err_LWFSVSS_r15  = (err(61:70,:,:));
err_LWFSVSS_r30  = (err(71:80,:,:));
err_LWFSVSS_r45  = (err(81:90,:,:));

MDAE_LWFSSBL_R027_M027 = err_LWFSSBL_R027 - err_LWFSSBL_M027;
MDAE_LWFSSBL_R003_M003 = err_LWFSSBL_R003 - err_LWFSSBL_M003;
MDAE_LWFSSBL_R003_R027 = err_LWFSSBL_R003 - err_LWFSSBL_R027;
MDAE_LWFSSBL_M003_M027 = err_LWFSSBL_M003 - err_LWFSSBL_M027;

MDAE_LWFSVSS_r15_r30 = err_LWFSVSS_r15 - err_LWFSVSS_r30;
MDAE_LWFSVSS_r15_r45 = err_LWFSVSS_r15 - err_LWFSVSS_r45;
MDAE_LWFSVSS_r30_r45 = err_LWFSVSS_r30 - err_LWFSVSS_r45;

n = 10.*size(err,2).*size(err,3);
[~, p_MDAE_LWFSSBL_R027_M027] = ttest(MDAE_LWFSSBL_R027_M027(:))
[~, p_MDAE_LWFSSBL_R003_M003] = ttest(MDAE_LWFSSBL_R003_M003(:))
[~, p_MDAE_LWFSSBL_R003_R027] = ttest(MDAE_LWFSSBL_R003_R027(:))
[~, p_MDAE_LWFSSBL_M003_M027] = ttest(MDAE_LWFSSBL_M003_M027(:))

[~, p_MDAE_LWFSVSS_r15_r30] = ttest(MDAE_LWFSVSS_r15_r30(:))
[~, p_MDAE_LWFSVSS_r15_r45] = ttest(MDAE_LWFSVSS_r15_r45(:))
[~, p_MDAE_LWFSVSS_r30_r45] = ttest(MDAE_LWFSVSS_r30_r45(:))

% err_R027 = abs(err(21:30,:,:));
% err_R300 = abs(err(31:40,:,:));
% err_M006 = abs(err(41:50,:,:));
% err_M013 = abs(err(51:60,:,:));
% err_M027 = abs(err(61:70,:,:));

% RMSE_LWFSSBL_27 = abs(err(21:30,:,:))-abs(err(31:40,:,:));
% RMSE_LWFSSBL_03 = abs(err(41:50,:,:))-abs(err(51:60,:,:));
% RMSE_LWFSSBL_rect = abs(err(21:30,:,:))-abs(err(41:50,:,:));
% RMSE_LWFSSBL_maxre = abs(err(31:40,:,:))-abs(err(51:60,:,:));
% 
% RMSE_LWFSVSS_15_30 = abs(err(61:70,:,:))-abs(err(71:80,:,:));
% RMSE_LWFSVSS_15_45 = abs(err(61:70,:,:))-abs(err(81:90,:,:));
% RMSE_LWFSVSS_30_45 = abs(err(71:80,:,:))-abs(err(81:90,:,:));
% 
% n = 10.*size(err,2).*size(err,3);
% [~, p_RMSE_LWFSSBL_27] = ttest(RMSE_LWFSSBL_27(:))
% [~, p_RMSE_LWFSSBL_03] = ttest(RMSE_LWFSSBL_03(:))
% [~, p_RMSE_LWFSSBL_rect] = ttest(RMSE_LWFSSBL_rect(:))
% [~, p_RMSE_LWFSSBL_maxre] = ttest(RMSE_LWFSSBL_maxre(:))
% 
% [~, p_RMSE_LWFSVSS_15_30] = ttest(RMSE_LWFSVSS_15_30(:))
% [~, p_RMSE_LWFSVSS_15_45] = ttest(RMSE_LWFSVSS_15_45(:))
% [~, p_RMSE_LWFSVSS_30_45] = ttest(RMSE_LWFSVSS_30_45(:))

%% plotting

figure;
for idx=1:9
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
