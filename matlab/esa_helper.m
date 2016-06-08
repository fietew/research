function [D, idx] = esa_helper(x0, xs, src, f, conf)
    idx = true(size(x0,1),1);
    D = driving_function_mono_esa_rect(x0,xs,src,f,conf);
end