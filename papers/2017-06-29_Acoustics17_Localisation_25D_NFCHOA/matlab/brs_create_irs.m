function brs_create_irs( conf )
%

%% ===== Configuration ==================================================
xs = conf.xs;  % source position
method = conf.method;  % SFS method
order = conf.nfchoa.order;  % order of modal representation
pos = conf.pos;  % listener position
fs = conf.fs;  % sample rate
c = conf.c;  % speed of sound

X0 = conf.secondary_sources.center;
R0 = conf.secondary_sources.size/2;

hrirs = conf.hrirs;
outputdir = conf.outputdir;

% switch off the stupid warnings for not using wavwrite and wavread anymore
warning('off', 'MATLAB:audiovideo:wavwrite:functionToBeRemoved');
warning('off', 'MATLAB:audiovideo:wavread:functionToBeRemoved');

%% ===== Computation ====================================================

% propagation direction of plane wave
phis = atan2( xs(:,2), xs(:,1) );

% === driving functions ===
switch method
  case 'ref'
    x0 = [-xs, xs, 1];
    d = 1;
    pos = [0,0,0];
  case 'pw'
    % === Modally bandwidth-limited plane wave ===
    % secondary source positions used for plane waves
    x0 = secondary_source_positions(conf);
    % invert secondary source positions to get propagation direction
    phi0 = atan2(-x0(:,2),-x0(:,1));
    % modal weighting function
    wm = modal_weighting(order, conf);
    % inverse DTFT of weighting function (weight for each plane wave)
    wm(2:end) = wm(2:end)*2;  % weighting for real-valued inverse DTFT
    win = wm*cos((phi0-phis)*(0:order)).'./(2*pi);  % real-valued inverse DTFT
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % the toolbox does not support the binaural simulation of plane waves.
    % Delays and weighting of the hrirs are computing based on point sources.
    % In order to circumvent this, some functionalities have to implemented by 
    % hand.
    
    % delay due to propagation of invidual plane wave to listener
    tau = pos(1:2)*[cos(phi0.'); sin(phi0.')]./c;    
    % length of delayline input to cover all possible listener positions inside
    % the listening area
    Nsamples = 2.^(1+ceil(log2(2*R0/c*fs)));    
    % apply and weights    
    d = zeros(Nsamples, length(win));
    d(1,:) = 1;
    d = delayline( d, tau-min(tau), win, conf);    
    % center listening position in order to have the same weights for all hrirs
    pos = X0;
    % HACK: compensates propagation delay of secondary sources to listener
    conf.ir.hrirpredelay = R0/c*fs;  
    % as the propagation delay is always 0, integer delayline is sufficient
    conf.delayline.filter = 'integer';
  case 'nfchoa'
    % === NFC-HOA ===
    % Loudspeaker positions
    x0 = secondary_source_positions(conf);
    % Calculate driving function
    d = driving_function_imp_nfchoa(x0,xs,'pw',conf);
  otherwise
    error('%s: unknown method (%s)', upper(mfilename), method);
end

% === binaural synthesis ====
phi = phis+pi;  % listener faces plane wave
ir = ir_generic(pos, phi, x0, d, hrirs, conf);

outfile = sprintf( '%s/brs_%s.wav', outputdir, brs_nameprefix( conf ) );
wavwrite(0.9*norm_signal(ir), fs, outfile);
