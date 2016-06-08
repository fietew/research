function [D, idx] = localwfs_helper(x0, xs, src, f, conf)    
    [D, ~, ~, idx] = driving_function_mono_localwfs(x0,xs,src,f,conf);
end
