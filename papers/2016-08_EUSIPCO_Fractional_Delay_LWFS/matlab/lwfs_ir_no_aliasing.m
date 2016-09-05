function res = lwfs_ir_no_aliasing(conf)
% computing spectrum of reproduced sound field at xref
% (no optimization of pre-filter)

%% ===== Computation =====================================================
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