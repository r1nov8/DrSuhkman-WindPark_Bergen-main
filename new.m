function [vecXTurbines, vecYTurbines] = generate_turbine_coordinates(shiftAlternateRows)
    D = 198;  % Diameter of each turbine in meters
    spacing_streamwise = 7 * D; % Streamwise spacing in meters (7D, along x-axis)
    spacing_spanwise = 3 * D;   % Spanwise spacing in meters (4D, along y-axis)
    rotor_length = D;  % Rotor length, typically approximate to turbine diameter
    wind_speed = 10.28;  % Example wind speed in m/s
    wind_direction = 20;  % Wind coming from the west, blowing east

    % Convert wind direction to radians for rotation calculations
    perpendicular_angle = deg2rad(wind_direction + 90); % Rotor lines should be perpendicular to the wind direction

    % Manually set the number of turbines for each column
    turbines_per_column = [5, 10, 10, 10, 10, 10, 10, 10]; % Custom turbine count per column

    % Initialize coordinate arrays
    total_turbines = sum(turbines_per_column);
    vecXTurbines = zeros(total_turbines, 1);
    vecYTurbines = zeros(total_turbines, 1);

    % Main figure and subplot for turbine layout
    figure;
    mainPlot = subplot('Position', [0.1 0.1 0.63 0.8]);  % Main plot
    hold on;
    title('Wind Turbine Layout with Perpendicular Rotors');
    xlabel('Position along x-axis (meters)');
    ylabel('Position along y-axis (meters)');
    grid on;
    axis equal;

    idx = 1;
    for col = 1:length(turbines_per_column)
        turbines_in_current_column = turbines_per_column(col);
        max_turbines = max(turbines_per_column);
        vertical_offset = (max_turbines - turbines_in_current_column) / 2 * spacing_spanwise;
        
        for turbine = 1:turbines_in_current_column
            x_center = (col - 1) * spacing_streamwise;
            y_center = vertical_offset + (turbine - 1) * spacing_spanwise + ...
                       (shiftAlternateRows && mod(col, 2) == 1) * (spacing_spanwise / 2);
            
            vecXTurbines(idx) = x_center;
            vecYTurbines(idx) = y_center;

            x_end1 = x_center + (rotor_length/2) * cos(perpendicular_angle);
            y_end1 = y_center + (rotor_length/2) * sin(perpendicular_angle);
            x_end2 = x_center - (rotor_length/2) * cos(perpendicular_angle);
            y_end2 = y_center - (rotor_length/2) * sin(perpendicular_angle);
            plot([x_end1, x_end2], [y_end1, y_end2], 'b', 'LineWidth', 2);

            idx = idx + 1;
        end
    end

    [X, Y] = meshgrid(min(vecXTurbines):500:max(vecXTurbines), min(vecYTurbines):500:max(vecYTurbines));
    U = wind_speed * cosd(wind_direction) * ones(size(X));
    V = wind_speed * sind(wind_direction) * ones(size(Y));
    quiver(X, Y, U, V, 'r', 'AutoScaleFactor', 0.5, 'MaxHeadSize', 2);

    % Subplot for detailed view with correct annotations
    detailPlot = subplot('Position', [0.78 0.1 0.15 0.8]);
    hold on;
    title('Detailed View with Rotors');
    xlabel('Position along x-axis (meters)');
    ylabel('Position along y-axis (meters)');
    grid on;
    axis equal;

    % Include wind vectors in main plot
    [X, Y] = meshgrid(min(vecXTurbines):500:max(vecXTurbines), min(vecYTurbines):500:max(vecYTurbines));
    U = wind_speed * cosd(wind_direction) * ones(size(X));
    V = wind_speed * sind(wind_direction) * ones(size(Y));
    quiver(X, Y, U, V, 'r', 'AutoScaleFactor', 0.5, 'MaxHeadSize', 2);

    % Define the target indices for turbines at (0,0), (0,4D), and (7D,4D)
    origin_idx = 1;  % Turbine at (0,0)
    target_indices = [origin_idx, origin_idx + 1, turbines_per_column(1) + 4];  % First turbine in second column

    for i = 2:length(target_indices)
        plot([vecXTurbines(origin_idx), vecXTurbines(target_indices(i))], ...
             [vecYTurbines(origin_idx), vecYTurbines(target_indices(i))], 'k--');
        distance = sqrt((vecXTurbines(target_indices(i)) - vecXTurbines(origin_idx))^2 + ...
                        (vecYTurbines(target_indices(i)) - vecYTurbines(origin_idx))^2) / D;
        angle = atan2d(vecYTurbines(target_indices(i)) - vecYTurbines(origin_idx), ...
                       vecXTurbines(target_indices(i)) - vecXTurbines(origin_idx));
        midx = (vecXTurbines(origin_idx) + vecXTurbines(target_indices(i))) / 2;
        midy = (vecYTurbines(origin_idx) + vecYTurbines(target_indices(i))) / 2;
        text(midx, midy, sprintf('%.1fD\n%.1f°', distance, angle), ...
             'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
    end

    for i = target_indices
        x_center = vecXTurbines(i);
        y_center = vecYTurbines(i);
        x_end1 = x_center + (rotor_length/2) * cos(perpendicular_angle);
        y_end1 = y_center + (rotor_length/2) * sin(perpendicular_angle);
        x_end2 = x_center - (rotor_length/2) * cos(perpendicular_angle);
        y_end2 = y_center - (rotor_length/2) * sin(perpendicular_angle);
        plot([x_end1, x_end2], [y_end1, y_end2], 'b', 'LineWidth', 2);
        
        % Including quiver plot in the detailed subplot
        quiver(x_center, y_center, wind_speed * cosd(wind_direction), wind_speed * sind(wind_direction), 'r', ...
               'AutoScaleFactor', 1, 'MaxHeadSize', 0.5);
    end

    xlim([min(vecXTurbines(target_indices))-D, max(vecXTurbines(target_indices))+D]);
    ylim([min(vecYTurbines(target_indices))-D, max(vecYTurbines(target_indices))+D]);

            % Print normalized vectors
    fprintf('A.vecXTurbines = [');
    fprintf('%.2f ', vecXTurbines / D);
    fprintf('];\n');
    fprintf('A.vecYTurbines = [');
    fprintf('%.2f ', vecYTurbines / D);
    fprintf('];\n');

    hold off;
end

% Example of calling the function
generate_turbine_coordinates(true);  % With shifting
