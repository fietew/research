function bsPlotPWD(P, p, kpw, fpw, tpw)
% function for plotting plane wave decomposition
% 
% F.Winter, F.Schultz, S.Spors

figure
subplot(1,2,1)
bsPlotPWDFrequency(P, kpw, fpw);
subplot(1,2,2)
bsPlotPWDTime(p, kpw, tpw, true);

end

