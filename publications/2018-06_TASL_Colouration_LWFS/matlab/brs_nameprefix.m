function prefix = brs_nameprefix( conf )

% position of listener
prefix = sprintf( 'posx%02.02f_posy%02.02f', ...
  conf.pos(1), conf.pos(2));

% if sfs technique, then specification of loudspeaker array
if any( strcmp(conf.method,  {'wfs', 'nfchoa', 'lwfs-sbl', 'lwfs-vss'}) )
  prefix = sprintf( '%s_%s_nls%04.0f_dls%02.02f', prefix, ...
    conf.secondary_sources.geometry, conf.secondary_sources.number, ...
    conf.secondary_sources.size);
end

prefix = sprintf( '%s_%s', prefix, conf.method );

% if reproduction technique
switch conf.method
case 'nfchoa'
    prefix = sprintf( '%s_M%02.0f', prefix, conf.nfchoa.order);
    prefix = sprintf( '%s_%s', prefix, get_modal_window(conf));
case 'lwfs-sbl'
    prefix = sprintf( '%s_M%02.0f', prefix, conf.localwfs_sbl.order);
    prefix = sprintf( '%s_%s', prefix, get_modal_window(conf));
    prefix = sprintf( '%s_npw%04.0f', prefix, conf.localwfs_sbl.Npw);
case 'lwfs-vss'
    prefix = sprintf( '%s_%s_nvs%04.0f_dvs%02.02f_%s', prefix, ...
        conf.localwfs_vss.geometry, ...
        conf.localwfs_vss.number, ...
        conf.localwfs_vss.size, ...
        conf.localwfs_vss.method);
    
    if strcmp(conf.localwfs_vss.method, 'nfchoa')
        prefix = sprintf( '%s_M%02.0f', prefix, conf.localwfs_vss.nfchoa.order);
        prefix = sprintf( '%s_%s', prefix, get_modal_window(conf));
    end
end

end

function s = get_modal_window( conf )    
  s = conf.modal_window;
  if strcmp(conf.modal_window, {'kaiser', 'tukey'})
     s = sprintf('%s%02.02f', s, conf.modal_window_parameter);
  end
end
