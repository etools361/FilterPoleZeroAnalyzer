%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2022-10-10(yyyy-mm-dd)
% 绘图
%--------------------------------------------------------------------------
function [InitEn] = funPlotParameter(app, iP, rP, iZ, rZ, ff, yf, HsFR, MagFp, Hs, Hs0, InitEn)
    global G_Data;
    f0   = G_Data.f0;
    freq = G_Data.freq;
    fp   = G_Data.fp;
    F3DX = G_Data.F3DX;
    F3DY = G_Data.F3DY;
    N    = G_Data.N;
    %-------------plot PZ----------------
    if InitEn
        axPlotPZ = app.UIAxes_PZ;                            G_Data.axPlotPZ      = axPlotPZ;
        h1 = plot(axPlotPZ, iP, rP, 'xb', 'LineWidth', 1);   G_Data.h1      = h1;
        grid(axPlotPZ, 'on');
        hold(axPlotPZ, 'on');
        h2 = plot(axPlotPZ, iZ, rZ, 'ob', 'LineWidth', 1);   G_Data.h2      = h2;
        h3 = plot(axPlotPZ, f0, 0.*f0, 'r', 'LineWidth', 1); G_Data.h3      = h3;
        % 辅助线
        h4 = plot(axPlotPZ, ff, yf, '-m', 'LineWidth', 0.1); G_Data.h4      = h4;
        hold(axPlotPZ, 'off');
        axis(axPlotPZ, 'square');
        ylabel(axPlotPZ, 'real/Hz');
        xlabel(axPlotPZ, 'imag/Hz');
        xlim(axPlotPZ, [freq(1), freq(end)]);
        ylim(axPlotPZ, [freq(1), freq(end)]);
        title(axPlotPZ, 'PZ Plot');

        % --------------------plot FR--------------------
        axPlotFR = app.UIAxes_FR;                                 G_Data.axPlotFR      = axPlotFR;
        h5 = semilogx(axPlotFR, f0, HsFR, '-r', 'LineWidth', 2);  G_Data.h5      = h5;
        hold(axPlotFR,"on");
        h6 = semilogx(axPlotFR, fp, MagFp, '*b', 'LineWidth', 1); G_Data.h6      = h6;
        hold(axPlotFR,"off");
        xlim(axPlotFR,[f0(1), f0(end)]);
        ylim(axPlotFR,[-90, 10]);
        xlabel(axPlotFR,'Freq/Hz');
        ylabel(axPlotFR,'Mag/dB');
        title(axPlotFR, 'Frequency Response');
        grid(axPlotFR, "on");

        %-------------plot 3D----------------
        axPlot3D = app.UIAxes_3D;                                 G_Data.axPlot3D      = axPlot3D;
        h7 = surf(axPlot3D, F3DX, F3DY, Hs);                      G_Data.h7      = h7;
        hold(axPlot3D, 'on');
        x3d  = F3DX(N/2:end,end);
        y3d  = F3DY(N/2:end,end);
        h8 = plot3(axPlot3D, x3d, y3d, Hs0, '-*r');               G_Data.h8      = h8;
        hold(axPlot3D, 'off');
        xlim(axPlot3D,[F3DX(1,1), F3DX(1,end)]);
        ylim(axPlot3D,[F3DY(1,1), F3DY(end,1)]);
        grid(axPlot3D, 'on');
        xlabel(axPlot3D,'real/Hz');
        ylabel(axPlot3D,'imag/Hz');
        zlim(axPlot3D, [-90, 20]);
        view(axPlot3D, [2,1,2]);
    else
%         axPlotPZ    = G_Data.axPlotPZ;
%         axPlotFR    = G_Data.axPlotFR;
%         axPlot3D    = G_Data.axPlot3D;
        h1          = G_Data.h1;
        h2          = G_Data.h2;
%         h3          = G_Data.h3;
        h4          = G_Data.h4;
        h5          = G_Data.h5;
        h6          = G_Data.h6;
        h7          = G_Data.h7;
        h8          = G_Data.h8;
        set(h1, 'XData', iP, 'YData', rP);
        set(h2, 'XData', iZ, 'YData', rZ);
%         set(h3, 'XData', iP, 'YData', rP);
        set(h4, 'XData', ff, 'YData', yf);
        set(h5, 'YData', HsFR);
        set(h6, 'XData', fp, 'YData', MagFp);
        set(h7, 'ZData', Hs);
        set(h8, 'ZData', Hs0);
    end
    InitEn = 0;
end