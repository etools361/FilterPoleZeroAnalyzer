%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2022-10-10(yyyy-mm-dd)
% 计算参数
%--------------------------------------------------------------------------
function [iP, rP, iZ, rZ, ff, yf, HsFR, MagFp, Hs, Hs0, P, Z] = funCalcuParameter(G_Data, IdealPZEn)
    fType  = G_Data.fType;
    TeeEn  = G_Data.TeeEn;
    n      = G_Data.n;
    Rs     = G_Data.Rs;
    Rl     = G_Data.Rl;
    fp     = G_Data.fp;
    fs     = G_Data.fs;
    Ap     = G_Data.Ap;
    As     = G_Data.As;
    bw     = G_Data.bw;
    fShape = G_Data.fShape;
    f0     = G_Data.f0;
    f1     = G_Data.f1;
    N      = G_Data.N;
    s0     = G_Data.s0;
    s      = G_Data.s;
    theta  = G_Data.theta;
    if IdealPZEn
        [IdealFreq, IdealMag, IdealPhase, P, Z] = funSimFilterIdeal(fType, TeeEn, n, Rs, Rl, fp, fs, Ap, As, bw, fShape, 0.1, 1, 2);
    else
        P = G_Data.P;
        Z = G_Data.Z;
    end
    iP  = imag(P);
    rP  = real(P);
    iZ  = imag(Z);
    rZ  = real(Z);
    % 计算复平面详细
    nEs = length(Z);
    nPs = length(P);
    Es  = 1; Es0 = 1;
    Ps  = 1; Ps0 = 1;
    for jj=1:nEs
        Es0 = Es0.*(s0+Z(jj))./Z(jj);
        Es  = Es.*(s+Z(jj))./Z(jj);
    end
    for jj=1:nPs
        Ps0 = Ps0.*(s0+P(jj))./P(jj);
        Ps  = Ps.*(s+P(jj))./P(jj);
    end
    Hs   = 10.*log10(abs(Es./Ps));
    Hs0  = Hs(N/2:end,end);
    HsFR = 10.*log10(abs(Es0./Ps0));
    Hs(Hs>20) = 20;
    Hs(Hs<-91) = -91;
    % 辅助线
    epsilon   = sqrt(10^(0.1*Ap)-1);% 通带衰减量
    switch fType
        case 'Butterworth'
            aE  = (epsilon)^(-1/n);
            ff   = fp.*aE.*cos(theta);
            yf   = fp.*aE.*sin(theta);
        case 'Chebyshev I'
            phi2      = 1/n*asinh(1/epsilon);
            if mod(n, 2)
                ff   = fp.*cosh(phi2).*sin(theta);
                yf   = -fp.*sinh(phi2).*cos(theta);
            else
                v2        = (n-1)*pi/(2*n);
                Zv = 1i.*cosh(phi2).*sin(theta) + sinh(phi2).*cos(theta);
                KK2 = sign(real(Zv)).*sqrt(Zv.^2 + cos(v2).^2)./sin(v2);
                ff   = fp.*imag(KK2);
                yf   = fp.*real(KK2);
            end

        case 'Chebyshev II'
            epsilon2 = sqrt(10^(0.1*As)-1);% 阻带衰减量
            K    = cosh(1/n*acosh(epsilon2/epsilon));
            phi2 = 1/n*asinh(epsilon2);
            Zv  = (-sinh(phi2).*sin(theta) + 1i.*cosh(phi2).*cos(theta));
            if mod(n, 2)
                KK2 = K./Zv;
            else
                v2        = (n-1)*pi/(2*n);
                K = sqrt((K).^2 + cos(v2).^2)./sin(v2);
                KK2       = sign(real(Zv)).*K./(sqrt((Zv).^2 + cos(v2).^2)./sin(v2));
            end
            ff   = fp.*imag(KK2);
            yf   = fp.*real(KK2);
        case 'Elliptic'
            es   = sqrt(10^(0.1*As)-1);% 阻带衰减量
            ep   = epsilon;%sqrt(10^(0.1*Ap)-1);% 截止频率处衰减量
            k1   = ep/es;
            k    = ellipdeg(n, k1);
            v2   = (n-1)/(n);
            wa   = cde(v2, k);
            wb   = 1./(k*cde((n-1)/n, k));
            aa   = wb^2;
            dd   = (-1+wb^2)/(1-wa^2);
            bb   = dd*wa^2;
            cc   = 1;
%             phi2      = 1/n*asinh(1/epsilon);
            v0     = asne(1i/ep, k1)/n;
            KK2    = 1i*cde(theta+v0, k);
            if ~mod(n, 2)
                KK2 = sign(real(KK2)).*(sqrt((dd.*KK2.^2+bb)./(cc.*KK2.^2+aa)));
            end
%                 KK1    = 1i./(k*cde(u, k));
%                 ff   = fp.*cosh(phi2).*sin(theta);
%                 yf   = -fp.*sinh(phi2).*cos(theta);
%                 v2        = (n-1)*pi/(2*n);
%                 Zv = 1i.*cosh(phi2).*sin(theta) + sinh(phi2).*cos(theta);
%                 KK2 = sign(real(Zv)).*sqrt(Zv.^2 + cos(v2).^2)./sin(v2);
            ff   = fp.*imag(KK2);
            yf   = fp.*real(KK2);
        case 'Bessel'
            aE  = (epsilon)^(-1/n);
            [N2, D2, ND] = fun_bessel_thomson_polynomial(n);
            [absH] = funCalcuHjw2(ND);
            [w1] = funGetBesselNormFreq(absH, epsilon);
            [ry, iy]=funAntiStokesLine();
%             ff   = fp.*aE.*ry.*max(real(P));
%             yf   = fp.*aE.*iy.*max(real(P));
            ff   = fp.*aE.*ry.*sqrt(n.*(n+1))./w1;
            yf   = fp.*aE.*iy.*sqrt(n.*(n+1))./w1;
        case 'Gaussian'
            aE  = (epsilon)^(-1/n);
            [N2, D2, ND] = fun_gaussian_polynomial(n, epsilon);
            [absH] = funCalcuHjw2(ND);
            [w1] = funGetGaussianNormFreq(absH, epsilon);
            [ry, iy]=funSzegoCurve(n);
            ff   = fp.*aE.*ry.*n./w1./1.06;
            yf   = fp.*aE.*iy.*n./w1./1.06;
        case 'Legendre'
            aE  = (epsilon)^(-1/n);
            [N2, D2, ND] = fun_legendre_polynomial(n, epsilon);

            [ry, iy]=funSzegoCurve(n);
            ff   = fp.*aE.*ry.*n;
            yf   = fp.*aE.*iy.*n;
        case 'LinearAmp'
            aE  = (epsilon)^(-1/n);
            IL   = 10^(-Ap/20);
            [N2, D2, ND] = fun_linear_amp_polynomial(n, IL);

            [ry, iy]=funSzegoCurve(n);
            ff   = fp.*aE.*ry.*n;
            yf   = fp.*aE.*iy.*n;
        otherwise
            fprintf('fType Error(%s)', fType);
    end
    MagFp = interp1(f0, HsFR, fp);
end