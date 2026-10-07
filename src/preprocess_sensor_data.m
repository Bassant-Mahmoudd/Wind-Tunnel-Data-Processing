function sensor_data = preprocess_sensor_data(filename, c)
    experimental_data = readtable(filename);
    
    % Average every 4 consecutive readings per AoA
    n = 4;
    start_row = 4;
    [num_rows, num_cols] = size(experimental_data);
    num_groups = floor((num_rows - start_row + 1) / n);
    means_matrix = zeros(num_groups, num_cols);
    
    for col = 1:num_cols
        vec = experimental_data{start_row:end, col};
        reshaped = reshape(vec(1:num_groups*n), n, []);
        means_matrix(:, col) = mean(reshaped, 1)';
    end
    
    exp_means = array2table(means_matrix, 'VariableNames', experimental_data.Properties.VariableNames);
    
    % Extract sensor readings
    sensor_data.Ps_inf = [exp_means.Var2];
    sensor_data.Pt_inf = [exp_means.Var3];
    sensor_data.X_c_Upper = [experimental_data{1, 5:16}];
    sensor_data.X_Upper = sensor_data.X_c_Upper .* c;
    sensor_data.Ps_upper = [exp_means{:, 5:16}];
    
    sensor_data.X_c_Lower = [experimental_data{1, 18:28}];
    sensor_data.X_Lower = sensor_data.X_c_Lower .* c;
    sensor_data.Ps_lower = [exp_means{:, 18:28}];
    
    sensor_data.Rake_vertical_pos = [experimental_data{1, 30:42} ./ 1000];
    sensor_data.Pt_wake = [exp_means{:, 30:42}];
    
    % Cap static pressure at freestream total pressure to fix sensor error
    for i = 1:size(sensor_data.Ps_upper, 1)
        sensor_data.Ps_upper(i, sensor_data.Ps_upper(i, :) > sensor_data.Pt_inf(i)) = sensor_data.Ps_inf(i);
        sensor_data.Ps_lower(i, sensor_data.Ps_lower(i, :) > sensor_data.Pt_inf(i)) = sensor_data.Ps_inf(i);
    end
end