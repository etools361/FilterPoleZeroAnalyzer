%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2022-10-10(yyyy-mm-dd)
% 初始化
%--------------------------------------------------------------------------
function [G_Data] = funInitParameter(app)
    fShape = app.ResponseDropDown.Value;          G_Data.fShape = fShape;
    n      = str2double(app.OrderDropDown.Value); G_Data.n      = n;
    Rs     = 1;                                   G_Data.Rs     = Rs;
    Rl     = 1;                                   G_Data.Rl     = Rl;
    fp     = str2double(app.FpEditField.Value);   G_Data.fp     = fp;
    Ap     = str2double(app.ApEditField.Value);   G_Data.Ap     = Ap;
    fs     = [];                                  G_Data.fs     = fs;
    bw     = [];                                  G_Data.bw     = bw;
    As     = str2double(app.AsEditField.Value);   
    fType  = app.FilterTypeDropDown.Value;        G_Data.fType  = fType;
    TeeEn  = 1;                                   G_Data.TeeEn  = TeeEn;
    f1     = 1;                                   G_Data.f1     = f1;
    N      = 200;                                 G_Data.N      = N;
    switch fType
        case 'Butterworth'
            f11 = fp*2;
        case 'Chebyshev I'
            f11 = fp*2;
            As  = 10.*log10(2);
        case 'Chebyshev II'
            f11 = fp*4;
        case 'Elliptic'
            f11 = fp*4;
        otherwise
            fprintf('fType Error(%s)', fType);
    end
    G_Data.As     = As;
    freq = linspace(-f11, f11, N);                G_Data.freq   = freq;
    theta = linspace(0, 2*pi, 200);               G_Data.theta  = theta;
    f3dx = freq(1:N/2);
    f3dy = freq;
    [F3DX, F3DY] = meshgrid(f3dx, f3dy);          G_Data.F3DX   = F3DX; G_Data.F3DY   = F3DY;
    s  = F3DX+1i.*F3DY;                           G_Data.s      = s;
    f0 = linspace(0, 4*fp, 5*N);                  G_Data.f0     = f0;
    s0 = 1i.*f0;                                  G_Data.s0     = s0;
end