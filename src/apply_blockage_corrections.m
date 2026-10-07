function corrected = apply_blockage_corrections(surface, wake, geom, tunnel)
    K1 = 0.76;
    sigma = ((pi^2)/48) * ((geom.c / tunnel.h)^2);
    V_airfoil = 0.7 * geom.t_max * geom.c * geom.b;
    
    epsilon_sb = K1 * V_airfoil / (tunnel.A^(3/2));
    epsilon_wb = (geom.c ./ (2*tunnel.h)) .* wake.Cd_uncorrected;
    epsilon = epsilon_sb + epsilon_wb;
    
    corrected.Cl = surface.Cl_uncorrected .* (1 - sigma - 2.*epsilon);
    corrected.Cd = wake.Cd_uncorrected .* (1 - 3.*epsilon_sb - 2.*epsilon_wb);
end