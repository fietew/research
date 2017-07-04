function nfchoa_directions( conf )
%

%% ===== Configuration ==================================================
xs = conf.xs;  % propagation of plane wave
pos = conf.pos;  % listener position
c = conf.c;  % speed of sound
fs = conf.fs;  % sample rate 

Nphi = conf.Nphi;  % resolution of apparent azimuth grid

% SSD
R0 = conf.secondary_sources.size/2;  % radius of secondary source distribution
X0 = conf.secondary_sources.center;  % center of secondary source distribution
% NFC-HOA
order = conf.nfchoa.order;  % order of truncation window
window = conf.nfchoa.modal_window;  % type of truncation window
N = conf.N;  % length of driving signals

%% ===== Computation ====================================================

% === NFC-HOA driving signals ===

% grid of of apparent azimuth
phi_pw = (0:2*pi/Nphi:2*pi*(1-1/Nphi));  % [1 x Nphi]
% secondary sources
x0 = secondary_source_positions(conf);
phi_0 = atan2(x0(:,2),x0(:,1));  % [N0 x 1]
% select secondary source matching the apparent azimuth
% NOTE: solves the equation for phi_0: 
%   pos + t*[cos(phi_pw), sin(phi_pw)] = X0 + R0*[cos(phi_0), sin(phi_0)]
phi_match = ....
  asin( ((X0(:,1:2)-pos(:,1:2))*[sin(phi_pw);-cos(phi_pw)])/R0 ) + phi_pw;
[~, select] = min( wrappedAD(bsxfun(@minus, phi_0, phi_match),2*pi), [], 1);

% plots to check correct loudspeaker selection
% figure;
% plot(x0(:,1), x0(:,2), 'k--');
% hold on;
% plot(pos(:,1), pos(:,2), 'bx');
% plot(R0*cos(phi_match), R0*sin(phi_match), 'ro');
% hold off;
% legend({'SSD', 'listener position', 'selected secondary sources'});
% axis equal;

% NFC-HOA 2.5D driving function
d = driving_function_imp_nfchoa(x0,xs,'pw',conf);
d = d(:,select);  % select driving signals [conf.N x Nphi]

% === Auditory Front End ===

% parameter for gammatone filterbank
afeSettings = genParStruct(...
    'fb_type', 'gammatone', ...
    'fb_lowFreqHz', 80, ...
    'fb_highFreqHz', 16000, ...
    'fb_nERBs', 1.0 ...
  );

% instantiation of data and manager objects
dataObj = dataObject([], fs, N/fs);
managerObj = manager(dataObj, {'filterbank'}, afeSettings);

fc = managerObj.Processors{2}.cfHz/1000;  % centre frequencies in kHz
% fprintf('%02.02f ', managerObj.Processors{2}.cfHz/1000);
% fprintf('\n');

D = zeros(size(d,2), length(fc));
for idx=1:size(d,2)
  managerObj.processChunk(d(:,idx), false);
  
  D(idx,:) = sqrt(sum(abs(dataObj.filterbank{1}.Data(:)).^2, 1));
  
  managerObj.reset;  % reset the manager
  dataObj.clearData();  % clear the data
end

% === Simulation of Distance ===

%  apparent distance depending on listening positions
r = vector_norm(bsxfun(@minus, pos(:,1:2), x0(select,1:2)), 2);
% weighting
D = bsxfun(@rdivide, D, r);
D = bsxfun(@rdivide, D, max(abs(D),[],1));  % normalize
% delay 
tau = r/c - R0/c;  % compensate delay due to radius of SSD
tau = tau*1000;  % scale to milliseconds

% figure;
% imagesc([managerObj.Processors{2}.cfHz], [phi_pw(1), phi_pw(end)], db(D));

% === Gnuplot ===

prefix = sprintf('posx%02.02f_posy%02.02f',pos(:,1),pos(:,2));
switch window
  case 'rect'
    prefix = sprintf('%s_rect_M%d', prefix, order);
  case 'kaiser'
    alpha = conf.nfchoa.modal_window_parameter;
    prefix = sprintf('%s_kaiser_M%d_alpha%02.02f', prefix, order, alpha);
end
gp_save( [prefix '_directions.txt'], [phi_pw.', tau, db(D)], ...
  'angle delay RMS_gammatone_channel' );
gp_save( 'fc.txt', [fc(:)] );


