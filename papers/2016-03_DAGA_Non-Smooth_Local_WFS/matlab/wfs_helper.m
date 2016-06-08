function [D, idx] = wfs_helper(x0, xs, src, f, conf)
    [x0, idx] = secondary_source_selection(x0,xs,src);
    x0 = secondary_source_tapering(x0,conf);
    D = driving_function_mono_wfs(x0,xs,src,f,conf);
end