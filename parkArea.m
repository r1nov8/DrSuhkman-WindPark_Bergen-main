function plot_area_map()
    % Define your area's boundary coordinates
    % Replace these example coordinates with your actual coordinates
    boundaryCoords = [
        59.6286, 4.2363; % Coordinate 1
        59.0288, 4.2338; % Coordinate 2
        58.9991, 4.2897; % Coordinate 3
        59.0002, 4.7383;
        59.1050, 4.8122;
        59.6280, 4.6180; % Coordinate 4
         % Coordinate 5
         % Coordinate 6
    ];

    % Plot the boundary on a simple XY plot
    figure;
    plot(boundaryCoords(:,2), boundaryCoords(:,1), '-o', ...
         'LineWidth', 2, 'MarkerSize', 5, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', [0.5,0.5,1]);
    xlabel('Longitude');
    ylabel('Latitude');
    title('Defined Area Boundary');
    grid on;
    
    % Enhance with Mapping Toolbox if needed
    % If you have the Mapping Toolbox, you can uncomment the following lines
    % to plot on a more detailed map:
    %
    % worldmap('World');
    % geoshow(boundaryCoords(:,1), boundaryCoords(:,2), 'DisplayType', 'polygon');
    %
    % This requires the Mapping Toolbox for the 'worldmap' and 'geoshow' functions.
end
