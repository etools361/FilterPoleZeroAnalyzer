%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2022-10-06(yyyy-mm-dd)
% 滤波器综合演示
%--------------------------------------------------------------------------
fType  = 'Chebyshev I';%'Butterworth';
fShape = 'LPF';
n     = 7;
Rs    = 2;
Rl    = 2;
fp    = 0.159;
fs    = 2;
Ap    = 3;
As    = Ap+15;
bw    = [];
TeeEn = 1;% TeeEn=0:PI, TeeEn=1:Tee
SimSW = 3;
% 滤波器综合
N     = 500;
f0 = 0.01;
f1 = 1;
NN = 120;
ApS = logspace(log10(1e-16), log10(6), NN);
theta = linspace(0, 2*pi, 100);
set(gcf,'color',[1,1,1]);
for ii=1:NN
    Ap = ApS(ii);
    ep   = sqrt(10^(0.1*Ap)-1);
    fp2 = fp./cos(1/n*acos(1/ep));
    [IdealFreq, IdealMag, IdealPhase, P, Z] = funSimFilterIdeal(fType, TeeEn, n, Rs, Rl, fp2, fs, Ap, As, bw, fShape, f0, f1, N);
%     f11 = fp*1.5;
%     freq = linspace(-f11, f11, N);
%     [FX, FY] = meshgrid(freq, freq);

    % contour(FX, FY, dBVo', [LowSlice,HightSlice], 'LineWidth', 2);
    subplot(1, 2, 1);
    plot(imag(P), real(P), 'xr');
    hold('on');
    plot(imag(Z), real(Z), 'or');
    phi = 1/n*asinh(1/ep);
    plot(fp2.*cosh(phi).*cos(theta), fp2.*sinh(phi).*sin(theta), '-b', 'LineWidth', 0.1);
    % grid on;xlabel('real/\delta');ylabel('imag/jw');axis square;xlim([-1, 1]);ylim([-1,1])
    hold('off');
    grid('on');
    axis('square');
    ylabel('real/Hz');
    xlabel('image/Hz');
    xlim([freq(1), freq(end)]);
    ylim([freq(1), freq(end)]);
    title('PZ Plot');
    subplot(1, 2, 2);
    semilogx(IdealFreq, IdealMag+6, '-b', 'LineWidth', 2);
    hold on;
    MagFp = interp1(IdealFreq, IdealMag+6, fp);
    MagFs = interp1(IdealFreq, IdealMag+6, fp2);
    semilogx(fp, MagFp, '*r', 'LineWidth', 2);
    semilogx(fp2, MagFs, 'ob', 'LineWidth', 2);
    hold off;
    xlim([IdealFreq(1), IdealFreq(end)]);
    ylim([-12, 0]);
    xlabel('Freq/Hz');
    ylabel('Mag/dB');
    title(sprintf('Chebyshev I Filter Frequency Response, Ap=%s dB, Fp = %s Hz', Data2Suffix(Ap, '05.1'), Data2Suffix(fp2, '05.1')));
    grid on;
    drawnow;
    pause(0.01);
end


