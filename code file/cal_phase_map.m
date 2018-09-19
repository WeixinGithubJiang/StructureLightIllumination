function phase_map = cal_phase_map(m)

tmp = m(:,:,2) - m(:,:,4);
small_costant = 1e-4;
phase_map = atan((m(:,:,1)-m(:,:,3))./(m(:,:,2)-m(:,:,4)));
phase_map(tmp<small_costant) = phase_map(tmp<small_costant) + pi;
phase_map = phase_map - pi/2;