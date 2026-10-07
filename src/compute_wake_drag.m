function wake_aero = compute_wake_drag(data, c, AOA)
    q_inf = data.Pt_inf - data.Ps_inf;
    wake_aero.Cp_wake = (data.Pt_wake - data.Ps_inf) ./ q_inf;
    
    num_angles = length(AOA);
    wake_aero.Cd_uncorrected = zeros(1, num_angles);
    
    for i = 1:num_angles
        % Calibration offset fix: use max rake pressure instead of Pt_inf
        Pt_rake_max = max(data.Pt_wake(i, :));
        q_rake = Pt_rake_max - data.Ps_inf(i);
        dp_wake = data.Pt_wake(i, :) - data.Ps_inf(i);
        
        u_over_v = sqrt(dp_wake ./ q_rake);
        integrand = u_over_v .* (1 - u_over_v);
        wake_aero.Cd_uncorrected(i) = (2/c) * trapz(data.Rake_vertical_pos(:), integrand(:));
    end
end