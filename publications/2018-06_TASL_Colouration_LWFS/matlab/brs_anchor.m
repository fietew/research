function brs = brs_anchor(brs,fs)
%BRS_ANCHOR filters the given reference BRS to generate a MUSHRA anchor
%
% Usage: brs = brs_anchor(brs,fs)
%
% A 2nd Order Butterworth high pass with cutoff at 5kHz is applied to
% generate the anchor brs.
cutoff = 5000;
[b,a] = butter(2,cutoff/fs,'high');
brs = filter(b,a,brs,[],1);
