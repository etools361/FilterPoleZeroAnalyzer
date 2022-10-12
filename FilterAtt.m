%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2022-10-08(yyyy-mm-dd)
% 滤波器衰减关系
%--------------------------------------------------------------------------
Rs=1;
N = 100;
Rl=logspace(log10(0.01),log10(100), N);
dA = 20.*log10(2.*sqrt(Rs.*Rl)./(Rs+Rl));

semilogx(Rl, dA, '-r', 'LineWidth', 2);
grid on;
