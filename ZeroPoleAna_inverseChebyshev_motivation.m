%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2022-10-06(yyyy-mm-dd)
% 滤波器综合演示
%--------------------------------------------------------------------------
fType  = 'Chebyshev II';%'Butterworth';
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
NN = 50;
ApS = logspace(log10(3), log10(90), NN);
ApS = fliplr(ApS);
theta = linspace(0, 2*pi, 200);
set(gcf,'color',[1,1,1]);



for ii=1:NN
    As = ApS(ii);
    epsilon   = 1/sqrt(10^(0.1*As)-1);% 阻带衰减量
    epsilon2  = 1/sqrt(10^(0.1*Ap)-1);% 截止频率处衰减量
    ep   = epsilon/epsilon2;
    K         = cosh(1/n*acosh(epsilon2/epsilon));
    fp3 = fp./cos(1/n*acos(1/ep));
    fp2 = fp;
    [IdealFreq, IdealMag, IdealPhase, P, Z] = funSimFilterIdeal(fType, TeeEn, n, Rs, Rl, fp2, fs, Ap, As, bw, fShape, f0, f1, N);
    Ap2 = 10.*log10(ep^2+1);
    [IdealFreq2, IdealMag2, IdealPhase2, P2, Z2] = funSimFilterIdeal('Chebyshev I', TeeEn, n, Rs, Rl, fp3, fs, Ap2, As, bw, fShape, f0, f1, N);
    [IdealFreq3, IdealMag3, IdealPhase3, P3, Z3] = funSimFilterIdeal('Butterworth', TeeEn, n, Rs, Rl, fp, fs, Ap2, As, bw, fShape, f0, f1, N);
    f11 = fp*3;
    freq = linspace(-f11, f11, N);
    phi = 1/n*asinh(1/ep);
    x1 = (imag(P));
    y1 = (real(P));
    fd = [zeros(1,2*n); x1];
    yd = fd.*y1./x1;
    phi2      = 1/n*asinh(1/epsilon);
    a = sinh(phi2).*sin(theta);
    b = cosh(phi2).*cos(theta);
    fshape = fp.*K.*b./(a.^2+b.^2);
    yshape = fp.*K.*a./(a.^2+b.^2);
    MagFp = interp1(IdealFreq, IdealMag+6, fp);
    MagFs = interp1(IdealFreq, IdealMag+6, fp.*K);
    felp  = fp3.*cosh(phi).*cos(theta);
    yelp  = fp3.*sinh(phi).*sin(theta);
    yclr  = fp3.*cosh(phi).*sin(theta);
    if ii==1
        subplot(1, 2, 1);
        h1 = plot(imag(P), real(P), 'xr', 'LineWidth', 2);
        hold('on');
        h2 = plot(imag(Z), real(Z), 'or', 'LineWidth', 2);
%         h2 = plot(imag(P2), real(P2), 'xb', 'LineWidth', 2);
        h3 = plot(imag(P3), real(P3), 'xg', 'LineWidth', 2);
%         h3 = plot(felp, yelp, '--b', 'LineWidth', 0.1);
        h4 = plot(felp, yclr, '--g', 'LineWidth', 0.1);
        h5 = plot(fd, yd, '-.k','LineWidth', 0.1);
        h6 = plot(fshape, yshape, '--r', 'LineWidth', 0.1);
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
        h7 = semilogx(IdealFreq, IdealMag+6, '-b', 'LineWidth', 2);
        hold on;
        h8 = semilogx(fp, MagFp, '*r', 'LineWidth', 2);
        h9 = semilogx(fp.*K, MagFs, 'ob', 'LineWidth', 2);
        hold off;
        xlim([IdealFreq(1), IdealFreq(end)]);
        ylim([-100, 0]);
        xlabel('Freq/Hz');
        ylabel('Mag/dB');
        h10 = title(sprintf('Chebyshev II Filter Frequency Response, Ap=%s dB, Fp = %s Hz', Data2Suffix(As, '04.1'), Data2Suffix(fp.*K, '05.1')));
        grid on;
    else
        set(h1, 'XData', imag(P), 'YData', real(P));
        set(h2, 'XData', imag(Z), 'YData', real(Z));
        set(h3, 'XData', felp, 'YData', yelp);
        set(h4, 'XData', felp, 'YData', yclr);
        for jj=1:2*n
            set(h5(jj), 'XData', fd(:,jj), 'YData', yd(:,jj));
        end
        set(h6, 'XData', fshape, 'YData', yshape);
        set(h7, 'XData', IdealFreq, 'YData', IdealMag+6);
        set(h8, 'XData', fp, 'YData', MagFp);
        set(h9, 'XData', fp.*K, 'YData', MagFs);
        set(h10, 'String', sprintf('Chebyshev II Filter Frequency Response, Ap=%s dB, Fp = %s Hz', Data2Suffix(As, '04.1'), Data2Suffix(fp.*K, '05.1')));
    end
    drawnow;
    pause(0.01);
end


