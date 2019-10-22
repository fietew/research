
%% parameters
% histogram bins
err_hist_bins = -20:2:20;  % bins for localisation error histogram
t_hist_bins = 0.5:1:35.5;  % bins for time-per-trial histogram
% significance level aka. (1 - confidence level)
alpha = 0.01;
% listening positions
x = [0.00; 0.25; 0.50; 0.75; 1.00; 0.00; 0.25; 0.50; 0.75; 1.00; 1.25;  0.00;  0.25;  0.50;  0.75;  1.00]*(-1);
y = [0.75; 0.75; 0.75; 0.75; 0.75; 0.00; 0.00; 0.00; 0.00; 0.00; 0.00; -0.75; -0.75; -0.75; -0.75; -0.75];
% loudspeaker array
phi0 = (0:55)*360/56;
x0 = 1.5*cosd(phi0);
y0 = 1.5*sind(phi0);

vecscale = 0.5;

results_dir = 'wierstorf/';

filenames = {
    'wierstorf_WFS_L56'
    'wierstorf_WFS_L28'
    'wierstorf_WFS_L14'
    'wierstorf_NFCHOA_L56_R028'
    'wierstorf_NFCHOA_L28_R014'
    'wierstorf_NFCHOA_L14_R007'
    'wierstorf_NFCHOA_L14_R028'
};

filemasks = {
    '_Y0.75m*.csv'
    '_Y0.00m*.csv'
    '_Y-0.75m*.csv'
    };

figure;
mdx = 0;
for method = {'wfs', 'hoa'}

    switch method{1}
        case 'wfs'
        	Nlsvec = [56, 28, 14];
        case 'hoa'
        	Nlsvec = [56, 28, 14, 1456];
    end
    
    for Nls = Nlsvec
        
        mdx = mdx+1;
    
        locerr = [];
        err = [];
        err_binaural = [];
        ci = [];
        locblur = [];
        MSEpos = [];
        MADerr = [];

        for mask = filemasks.'
            filelist = dir([results_dir,  method{1}, '/*', method{1}, mask{1}]);

            fdx = 0;
            err_tmp = [];
            time = [];
            for file = filelist.'
              fdx = fdx+1;
              % subject idx
              sdx = fdx;
              % parse the file for localisation azimuths and timestamps
              data = dlmread(fullfile(results_dir,  method{1},  file.name),',',10,0);
              % select speaker condition for calibration
              calib = data(data(:,2) == 0, :);
              offset = mean(calib(:, 9) - calib(:, 8));
              % select loudspeaker condition
              data = data(data(:,2) == Nls, :);
              % get unique conditions
              condition_ids = unique(data(:,3));
              % iterate over unique conditions
              for idx = 1:length(condition_ids)
                % 
                select = data(:,3) == condition_ids(idx);
                % signed localisation error
                err_tmp(idx,:,sdx) = data(select, 8) - data(select, 9) + offset;
                % time for each trial
                time(idx,:,sdx) = data(select, 12);
              end
              % error of corrected binaural synthesis data
              err_binaural = [err_binaural; calib(:, 8) - calib(:, 9) + offset];
            end

            err_stats = statistics(err_tmp, alpha, err_hist_bins);
            
            MSEpos = [MSEpos; mean(mean(abs(err_tmp).^2, 2), 3)];
            locerr = [locerr; err_stats.mean_cond];
            locblur = [locblur;  err_stats.std_cond];
            err = [err; err_tmp];
            ci = [ci; err_stats.mean_conf_cond];
        end

        gt = atan2d(x,2.5-y);
        loc = gt + locerr;

        %% subsampling
        select = [1:2:5,6:2:10,11,12:2:16];        
        
        %% statistical testing
%         RMSEpos = sqrt(MSEpos);
%         RMSEmethod = sqrt(mean(MSEpos(select,:),1));
        
        tmp = err(select,:,:);
        [~,p_loc] = ttest2(tmp(:), err_binaural(:), 'Vartype', 'unequal');
        
        blur_binaural = std(err_binaural); % std of binaural synthesis
        nu2 = length(err_binaural) - 1;
        
        locblur = sqrt(mean(locblur(select,:).^2,1));   
        nu1 = (size(err,2).*size(err,3)-1).*length(select);
        p_blur = fcdf(locblur.^2./blur_binaural.^2,nu1,nu2,'upper');

%         n = size(err,2).*size(err,3);
%         [~, p_RMSEpos] = RMSEtest2(RMSEpos, sigma, n, length(err_binaural), alpha);
% 
%         n = 10.*size(err,2).*size(err,3);
%         [~, p_RMSEmethod] = RMSEtest2(RMSEmethod, sigma, n, length(err_binaural), alpha);
    
        %% plotting    
        subplot(3,3,mdx);
        hold on;

        ciplot = [];
        for jdx=select
            r = vecscale.*0.75;
            phi = linspace(-ci(jdx),ci(jdx),360)+loc(jdx)+90;

            xci = [0, cosd(phi)];
            yci = [0, sind(phi)];

            fill(x(jdx)+r.*xci,y(jdx)+r.*yci,'r');

            ciplot = [ciplot,x(jdx,ones(1,361)).',y(jdx,ones(1,361)).',xci.',yci.'];
        end

        errtmp = err(select,:,:);
    
        gp_save([filenames{mdx} '_corrected.txt'], reshape(errtmp,size(errtmp,1),[]));
        gp_save([filenames{mdx} '_ci.txt'], ciplot);
        gp_save([filenames{mdx} '_loc.txt'], [x(select),y(select), loc(select), locerr(select)]);
        gp_save([filenames{mdx} '_avr.txt'], [mean(locerr(select)), p_loc, locblur, p_blur]);
        
        quiver(x,y,vecscale.*cosd(loc+90),vecscale.*sind(loc+90), 0);
        plot(x0,y0,'ko');
        hold off;
        axis equal 
    
    end
end