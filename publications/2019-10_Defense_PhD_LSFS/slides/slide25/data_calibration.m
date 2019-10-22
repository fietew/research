function [loc_corrected, calib_corrected] = data_calibration(calib,gt_calib,loc)

[Ncond, Nrep, Nsub] = size(calib);

sub = [];
sub(1,1,:) = 1:Nsub;
sub = repmat(sub, [Ncond, Nrep]);

err_calib = calib - gt_calib;
tbl = table(err_calib(:),gt_calib(:), sub(:),'VariableNames',{'Error','GroundTruth','Subject'});
tbl.Subject = categorical(tbl.Subject);

lme = fitlme(tbl,'Error~ GroundTruth + (GroundTruth|Subject)');

% BLUEs of fixed effect
[~,~,FE] = fixedEffects(lme);
beta_0 = FE.Estimate(1);
beta_1 = FE.Estimate(2);

% BLUPs of random effects
[~,~,RE] = randomEffects(lme);
gamma_0 = RE.Estimate(1:2:end);
gamma_1 = RE.Estimate(2:2:end);

% correct localisation azimuth (per subject)
loc_corrected = loc;
calib_corrected = calib;
for edx = 1:Nsub
    loc_corrected(:,1,edx) = (loc(:,1,edx) - beta_0 - gamma_0(edx))./(1 + beta_1 + gamma_1(edx));
    calib_corrected(:,:,edx) = (calib(:,:,edx) - beta_0 - gamma_0(edx))./(1 + beta_1 + gamma_1(edx));
end
