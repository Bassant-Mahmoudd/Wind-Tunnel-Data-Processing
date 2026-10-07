function visualize_comparisons(AOA, data, surface, wake, corrected, xfoil_file)
    % Load XFoil Data
    xfoil_data = readtable(xfoil_file);
    AOA_Xfoil = [xfoil_data.AngleOfAttack_Degrees_]; 
    Cl_XFoil = [xfoil_data.LiftCoefficient];
    Cm_Xfoil = [xfoil_data.PitchingMomentCoefficientAtC_4];
    Cd_Xfoil = [xfoil_data.DragCoefficient];

    % Plot 1: Pressure Coefficient Distributions
    X_c_Upper = data.X_c_Upper(:);
    X_c_Lower = data.X_c_Lower(:);  
    figure('Position', [100, 100, 1200, 500]);
    tiledlayout(2,3);
    for i = 1:length(AOA)
        nexttile;       
        plot(X_c_Upper, surface.Cp_upper(i,:), 'b-o', 'MarkerSize', 3, 'DisplayName', 'Upper');  
        hold on;
        plot(X_c_Lower, surface.Cp_lower(i,:), 'r-s', 'MarkerSize', 3, 'DisplayName', 'Lower');  
        xlabel('x/c'); ylabel('C_p'); title(['\alpha = ' num2str(AOA(i)) '^\circ']);
        set(gca, 'YDir', 'reverse'); grid on;
        if i == 1; legend('show', 'Location', 'best'); end
    end
    exportgraphics(gcf, 'wtunlpresdist.png', 'Resolution', 300);

    % Plot 2: Wake Pressure Distributions
    Rake_vertical_pos = data.Rake_vertical_pos(:);
    figure('Position', [100, 100, 1200, 500]);
    tiledlayout(2,3);  
    for i = 1:length(AOA)
        nexttile;       
        plot(Rake_vertical_pos, wake.Cp_wake(i,:), 'b-o', 'MarkerSize', 3);
        xlabel('Vertical Position'); ylabel('\textbf{ $C_P$}','Interpreter', 'latex');
        title(['\alpha = ' num2str(AOA(i)) '^\circ']); grid on;
    end
    exportgraphics(gcf, 'wtunlwakepresdist.png', 'Resolution', 300);

    % Plot 3: Lift Coefficient vs Angle of Attack
    figure('Position', [100, 100, 600, 500]); 
    plot(AOA, corrected.Cl, 'b-o', 'MarkerSize', 3, 'DisplayName', 'Exp (Corrected)');
    hold on;
    plot(AOA_Xfoil, Cl_XFoil,'r-s', 'MarkerSize', 3, 'DisplayName', 'xFoil');
    plot(AOA, surface.Cl_TAT, 'k', 'LineWidth', 1.5, 'DisplayName', 'Theory (2\pi\alpha)');
    xlabel('Angle of Attack (\alpha degrees)'); ylabel('\textbf{Lift Coefficient $C_l$}','Interpreter', 'latex');
    legend('Location', 'best'); grid on;
    exportgraphics(gcf, 'liftcoeff.png', 'Resolution', 300);

    % Plot 4: Drag Polar (Cl vs Cd)
    figure('Position', [120, 120, 620, 520]); 
    plot(corrected.Cd, corrected.Cl, 'b-o', 'MarkerSize', 3, 'DisplayName', 'Exp (Corrected)');
    hold on;
    plot(Cd_Xfoil, Cl_XFoil, 'r-s', 'MarkerSize', 3, 'DisplayName', 'xFoil');
    xlabel('\textbf{Drag Coefficient $C_d$}','Interpreter', 'latex'); ylabel('\textbf{Lift Coefficient $C_l$}','Interpreter', 'latex');
    legend('Location', 'best'); grid on;
    exportgraphics(gcf, 'dragpolar.png', 'Resolution', 300);

    % Plot 5: Pitching Moment Coefficient
    figure('Position', [100, 100, 600, 500]); 
    plot(AOA, surface.Cm, 'b-o', 'MarkerSize', 3, 'DisplayName', 'Experimental');
    hold on;
    plot(AOA_Xfoil, Cm_Xfoil, 'r-s', 'MarkerSize', 3, 'DisplayName', 'xFoil');
    xlabel('Angle of Attack (\alpha degrees)'); ylabel('Moment Coefficient ($C_m$)', 'Interpreter', 'latex');
    legend('Location', 'best'); grid on;
    exportgraphics(gcf, 'momentcoeff.png', 'Resolution', 300);

    % Plot 6: Aerodynamic Efficiency (Cl/Cd)
    figure('Position', [100, 100, 600, 500]);
    Cl_Cd_exp = corrected.Cl ./ corrected.Cd;
    Cl_Cd_xfoil = Cl_XFoil ./ Cd_Xfoil;
    plot(AOA_Xfoil, Cl_Cd_xfoil, 'r-s', 'MarkerSize', 3, 'DisplayName', 'xFoil');
    hold on;
    plot(AOA, Cl_Cd_exp, 'b-o', 'MarkerSize', 3,'DisplayName', 'Exp (Corrected)');
    xlabel('Angle of Attack (\alpha degrees)'); ylabel('Glide Ratio');
    legend('Location', 'best'); grid on;
    exportgraphics(gcf, 'glideratio.png', 'Resolution', 300);
end