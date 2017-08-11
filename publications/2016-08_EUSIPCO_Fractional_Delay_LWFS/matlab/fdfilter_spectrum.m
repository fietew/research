function fdfilter_spectrum(conf)
% computing spectrum of fdfilter

dt = conf.dt;
%% ===== Computation =====================================================
impulse = [1; zeros(511,1)];
[b, delay_offset] = delayline(impulse, dt, 1, conf);

% magnitude response
[H, w] = freqz(b,1,512);
H = abs(H);
w = w/(2*pi);
% phase delay
tau_phi = phasedelay(b, 1, 512) - delay_offset;

%% ===== Save File =======================================================
% if gnuplot file already exists, append data. Else, create gnuplot file
if exist(conf.datafile, 'file')
  [w, S] = gp_load(conf.datafile);
else
  S = [];
end
S = [S, H, tau_phi];

gp_save( conf.datafile, [w, S] );

end