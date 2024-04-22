function [vecXTurbines, vecYTurbines] = generate_turbine_coordinates(shiftAlternateRows)
    D = 242.24;  % Diameter of each turbine in meters
    spacing_streamwise = 7 * D; % Streamwise spacing in meters (7D, along x-axis)
    spacing_spanwise = 7 * D;   % Spanwise spacing in meters (7D, along y-axis)
    rotor_length = D;  % Rotor length, typically approximate to turbine diameter
    wind_speed = 10.28;  % Example wind speed in m/s
    wind_direction = 20;  % Wind coming from the west, blowing east

    % Convert wind direction to radians for rotation calculations
    perpendicular_angle = deg2rad(wind_direction + 90); % Rotor lines should be perpendicular to the wind direction

    % Turbine count per row and total rows
    turbines_per_row = 10;
    rows = 5;

    % Initialize coordinate arrays
    vecXTurbines = zeros(turbines_per_row * rows, 1);
    vecYTurbines = zeros(turbines_per_row * rows, 1);

    % Main figure and subplot for turbine layout
    figure;
    subplot('Position', [0.1 0.1 0.63 0.8]);  % Adjust position and size 
    hold on;
    title('Wind Turbine Layout with Perpendicular Rotors');
    xlabel('Position along x-axis (meters)');
    ylabel('Position along y-axis (meters)');
    grid on;
    axis equal;

    % Generate and plot coordinates for each turbine with perpendicular rotors
    idx = 1;
    for row = 0:rows - 1
        for turbine = 0:turbines_per_row - 1
            x_center = row * spacing_streamwise; % Center position of turbine in meters
            y_center = turbine * spacing_spanwise + (shiftAlternateRows && mod(row, 2) == 1) * 3.5 * D; % Adjust for alternate rows
            vecXTurbines(idx) = x_center;
            vecYTurbines(idx) = y_center;

            % Calculate end points of the rotor line perpendicular to wind
            x_end1 = x_center + (rotor_length/2) * cos(perpendicular_angle);
            y_end1 = y_center + (rotor_length/2) * sin(perpendicular_angle);
            x_end2 = x_center - (rotor_length/2) * cos(perpendicular_angle);
            y_end2 = y_center - (rotor_length/2) * sin(perpendicular_angle);

            % Plot each turbine as a line
            plot([x_end1, x_end2], [y_end1, y_end2], 'b', 'LineWidth', 2);

            idx = idx + 1;
        end
    end

    % Setup wind vector field across the entire grid
    [X, Y] = meshgrid(min(vecXTurbines):500:max(vecXTurbines), min(vecYTurbines):500:max(vecYTurbines));
    U = wind_speed * cosd(wind_direction) * ones(size(X)); % Wind vector in X direction
    V = wind_speed * sind(wind_direction) * ones(size(Y)); % Wind vector in Y direction
    quiver(X, Y, U, V, 'r', 'AutoScaleFactor', 1, 'MaxHeadSize', 2);

    % Subplot for zooming into the specific angles and distances
    subplot('Position', [0.78 0.1 0.15 0.8]);  % Make this subplot smaller
    origin_idx = 1;  % Turbine at (0,0)
    target_indices = [origin_idx, origin_idx + turbines_per_row, origin_idx + turbines_per_row + 1];  % Indices for (0,0), (0,7D), and (7D,7D)
    plot(vecXTurbines(target_indices), vecYTurbines(target_indices), 'b|', 'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'b');
    hold on;
    [X, Y] = meshgrid(min(vecXTurbines):500:max(vecXTurbines), min(vecYTurbines):500:max(vecYTurbines));
    U = wind_speed * cosd(wind_direction) * ones(size(X)); % Wind vector in X direction
    V = wind_speed * sind(wind_direction) * ones(size(Y)); % Wind vector in Y direction
    quiver(X, Y, U, V, 'r', 'AutoScaleFactor', 0.5, 'MaxHeadSize', 1);
    
    % Draw lines and annotate angles and distances for specific pairs
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

    grid on;
    axis equal;
    xlim([min(vecXTurbines(target_indices))-D, max(vecXTurbines(target_indices))+D]);
    ylim([min(vecYTurbines(target_indices))-D, max(vecYTurbines(target_indices))+D]);

        % Print normalized vectors
    fprintf('A.vecXTurbines = [');
    fprintf('%.2f ', vecXTurbines / D);
    fprintf('];\n');
    fprintf('A.vecYTurbines = [');
    fprintf('%.2f ', vecYTurbines / D);
    fprintf('];\n');
end

% Example of calling the function with and without shifting
generate_turbine_coordinates(true); % Without shifting