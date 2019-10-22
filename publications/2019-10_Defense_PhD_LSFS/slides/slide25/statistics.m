function stat = statistics(x, alpha, hist_bins)
%
% inputs:
%   ratings:  1st dim: conditions
%             2nd dim: repetitions
%             3nd dim: subjects
%
%   alpha: confidence value 

%% number of samples
stat.n_sub_cond = size(x, 2);
stat.n_sub = stat.n_sub_cond*size(x, 1);
stat.n_cond = stat.n_sub_cond*size(x, 3);
stat.n_all = numel(x);

%% histogram
stat.hist_bins = hist_bins;
% edges of bins
hist_edges = [-inf, 0.5*(hist_bins(2:end)+hist_bins(1:end-1)), inf];
% histogram pooled over listeners and repetitions
stat.hist_cond = histc(reshape(x, size(x,1), []), hist_edges, 2);
stat.hist_cond(:,end) = [];
stat.hist_cond = stat.hist_cond./numel(x(1,:,:));  % sum of hist is now one
% histogram pooled over conditions and repetitions
stat.hist_sub = histc(reshape(x, [], size(x,3)), hist_edges, 1);
stat.hist_sub(end,:) = [];
stat.hist_sub = stat.hist_sub./numel(x(:,:,1));  % sum of hist is now one
% histogram over all three dimensions
stat.hist_all = mean(stat.hist_cond, 1);

%% quantiles
stat.p = 0.05:0.05:0.95;
stat.quantiles_all = quantile(x(:), stat.p);

%% arithmetic mean
stat.mean_sub_cond = squeeze(mean(x, 2));  % for condition and subject
stat.mean_sub = squeeze(mean(stat.mean_sub_cond, 1));  % for subject
stat.mean_cond = mean(stat.mean_sub_cond, 2);  % for condition
stat.mean_all = mean(x(:));  % overall

%% standard deviation from the arithmetic mean
stat.std_sub_cond = squeeze(std(x, [], 2));
stat.std_sub = std(reshape(x, [], size(x, 3)), [], 1);
stat.std_cond = std(reshape(x, size(x, 1), []), [], 2);
stat.std_all = std(x(:));

%% confidence interval of arithmetic mean
% t-value
t_sub_cond = tinv(1-alpha/2, stat.n_sub_cond-1);
t_sub = tinv(1-alpha/2, stat.n_sub-1);
t_cond = tinv(1-alpha/2, stat.n_cond-1);
t_all = tinv(1-alpha/2, stat.n_all-1);
% distance between mean and upper confidence bound
stat.mean_conf_sub_cond = stat.std_sub_cond./sqrt(stat.n_sub_cond)*t_sub_cond;
stat.mean_conf_sub = stat.std_sub./sqrt(stat.n_sub)*t_sub;
stat.mean_conf_cond = stat.std_cond./sqrt(stat.n_cond)*t_cond;
stat.mean_conf_all = stat.std_all./sqrt(stat.n_all)*t_all;
% is the mean significantly different from zeros?
stat.mean_sign_sub_cond = abs(stat.mean_sub_cond) > stat.mean_conf_sub_cond;
stat.mean_sign_sub = abs(stat.mean_sub) > stat.mean_conf_sub;
stat.mean_sign_cond = abs(stat.mean_cond) > stat.mean_conf_cond;
stat.mean_sign_all = abs(stat.mean_all) > stat.mean_all;

%% confidence interval for standard deviation
% Xi-Squared-value
X2_lower_sub_cond = chi2inv(1-alpha/2, stat.n_sub_cond-1);
X2_upper_sub_cond = chi2inv(alpha/2, stat.n_sub_cond-1);
X2_lower_sub = chi2inv(1-alpha/2, stat.n_sub-1);
X2_upper_sub = chi2inv(alpha/2, stat.n_sub-1);
X2_lower_cond = chi2inv(1-alpha/2, stat.n_cond-1);
X2_upper_cond = chi2inv(alpha/2, stat.n_cond-1);
X2_lower_all = chi2inv(1-alpha/2, stat.n_all-1);
X2_upper_all = chi2inv(alpha/2, stat.n_all-1);
% 
stat.std_conf_lower_sub_cond = stat.std_sub_cond ...
  * sqrt((stat.n_sub_cond-1)./X2_lower_sub_cond);
stat.std_conf_upper_sub_cond = stat.std_sub_cond ...
  * sqrt((stat.n_sub_cond-1)./X2_upper_sub_cond);
stat.std_conf_lower_sub = stat.std_sub ...
  * sqrt((stat.n_sub-1)./X2_lower_sub);
stat.std_conf_upper_sub = stat.std_sub ...
  * sqrt((stat.n_sub-1)./X2_upper_sub);
stat.std_conf_lower_cond = stat.std_cond ...
  * sqrt((stat.n_cond-1)./X2_lower_cond);
stat.std_conf_upper_cond = stat.std_cond ...
  * sqrt((stat.n_cond-1)./X2_upper_cond);
stat.std_conf_lower_all = stat.std_all ...
  * sqrt((stat.n_all-1)./X2_lower_all);
stat.std_conf_upper_all = stat.std_all ...
  * sqrt((stat.n_all-1)./X2_upper_all);
