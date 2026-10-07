function surface_aero = compute_surface_aerodynamics(data, c, AOA)
    surface_aero.q_inf = data.Pt_inf - data.Ps_inf;
    surface_aero.Cp_upper = (data.Ps_upper - data.Ps_inf) ./ surface_aero.q_inf;
    surface_aero.Cp_lower = (data.Ps_lower - data.Ps_inf) ./ surface_aero.q_inf;
    
    num_angles = length(AOA);
    surface_aero.Cn = zeros(1, num_angles);
    surface_aero.Cm = zeros(1, num_angles);
    
    for i = 1:num_angles
        I_upper = trapz(data.X_Upper, surface_aero.Cp_upper(i,:));
        I_lower = trapz(data.X_Lower, surface_aero.Cp_lower(i,:));
        surface_aero.Cn(i) = (I_lower - I_upper) / c;
        
        term_upper = trapz(data.X_Upper, surface_aero.Cp_upper(i,:) .* (data.X_Upper - 0.25*c));
        term_lower = trapz(data.X_Lower, surface_aero.Cp_lower(i,:) .* (data.X_Lower - 0.25*c));
        surface_aero.Cm(i) = (1/(c^2)) * term_upper - (1/(c^2)) * term_lower;
    end
    
    surface_aero.Cl_uncorrected = surface_aero.Cn .* cosd(AOA);
    surface_aero.Cl_TAT = 2 * pi * deg2rad(AOA);
end