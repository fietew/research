SFS_start;

fs = 44100;
fc = 100;
rs = 1.5;
c = 343;
M = 6;

[zz, pz, kz] = linkwitz_riley(M,fc/fs*2,'high');
sos = zp2sos(zz,pz,kz);

[hlr,w] = freqz(sos, 2048);
f = w/pi*fs/2;

hsph = zeros(length(f),M+1);
for n=0:M
    hsph(:,n+1) = sphbesselh(n,2,2*pi*f/c*rs).*(2*pi*f/c);
end

hsph_comp = bsxfun(@times, hsph, hlr);

plot(f,db(hsph), 'Linewidth', 2);
hold on;
plot(f,db(hsph_comp), '--', 'Linewidth', 2);
plot(f,db(hlr), 'k-', 'Linewidth', 2);
grid on;
hold off;
axis tight;
ylim([-50, 50]);
set(gca, 'XScale', 'log');
xlabel('Frequency / Hz');
ylabel('Magnitude / dB');
lgd = legend('\mu = 0', ...
    '\mu = 1', ...
    '\mu = 2', ...
    '\mu = 3', ...
    '\mu = 4', ...
    '\mu = 5', ...
    '\mu = 6', ...
    '\mu = 0, reg.', ...
    '\mu = 1, reg.', ...
    '\mu = 2, reg.', ...
    '\mu = 3, reg.', ...
    '\mu = 4, reg.', ...
    '\mu = 5, reg.', ...
    '\mu = 6, reg.', ...
    'Linkwitz-Riley');
lgd.FontSize = 14;
