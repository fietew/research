function res = lwfs_ir(conf)

%% ===== Configuration ========================================================
% use high-order fractional delay filter to find pre-filter
highconf = conf;
highconf.delayline.resampling = 'pm';
highconf.delayline.resamplingfactor = 8;
highconf.delayline.resamplingorder = 64;
highconf.delayline.filter = 'lagrange';
highconf.delayline.filterorder = 9;

%% ===== Prefilter Optimization ===============================================
% calculate prefilter
[conf.wfs.hpreflow, conf.wfs.hprefhigh] = ...
  localwfs_findhpref(conf.xref, pi/2, conf.xs, conf.src, highconf);
conf.localsfs.wfs = conf.wfs;

%% ===== Fractional Delay =====================================================
% Get secondary sources
x0 = secondary_source_positions(conf);
% Get driving signals
[d, x0] = driving_function_imp_localwfs(x0, conf.xs, conf.src,conf);

for idx=1:size(d,2);
  [D(:,idx), Dphase(:,idx), f] = easyfft(d(:,idx), conf);
end

dist = sqrt(sum(bsxfun(@minus, x0(:,1:3), conf.xref).^2, 2)).';
P_lwfs = bsxfun(@rdivide, D.*exp(1j*(Dphase-2*pi*f*dist/conf.c)), 4*pi*dist);
P_lwfs = sum(bsxfun(@times,P_lwfs, x0(:,7).'), 2);

%% ===== Save File =======================================================
res.conf = conf;
res.x0 = x0;
res.d = d;
res.D = D.*exp(1j*Dphase);
res.f = f;
res.name = evalGenerateFilename(conf);
res.P = P_lwfs;

save([res.name, '.mat'], 'res');

end