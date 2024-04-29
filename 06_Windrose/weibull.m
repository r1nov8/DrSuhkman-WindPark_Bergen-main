% Liste av filnavn
filenames = {'NORA2012.csv', 'NORA2013.csv', 'NORA2014.csv', 'NORA2015.csv', 'NORA2016.csv', 'NORA2017.csv', 'NORA2018.csv', 'NORA2019.csv', 'NORA2020.csv', 'NORA2021.csv', 'NORA2022.csv'};

% Initialiser array for å holde alle vindhastigheter
all_wind_speeds = [];

% Loop gjennom hver fil
for i = 1:length(filenames)
    % Les data fra filen, starter fra rad 2
    opts = detectImportOptions(filenames{i}, 'NumHeaderLines', 1);
    data = readtable(filenames{i}, opts);
    
    % Tilgang til vindhastighetsdata ved å referere direkte til kolonneindeks
    all_wind_speeds = [all_wind_speeds; data{:,2}];
end

% Vis summarisk statistikk for de kombinerte vindhastighetsdataene
disp(['Total number of data points: ', num2str(length(all_wind_speeds))]);
disp(['Mean wind speed: ', num2str(mean(all_wind_speeds)), ' m/s']);
disp(['Standard deviation: ', num2str(std(all_wind_speeds)), ' m/s']);
disp(['Minimum wind speed: ', num2str(min(all_wind_speeds)), ' m/s']);
disp(['Maximum wind speed: ', num2str(max(all_wind_speeds)), ' m/s']);

% Estimer parametre for Weibull-distribusjonen
pd = fitdist(all_wind_speeds, 'Weibull');

% Utskrift av Weibull-parametere
disp(['Weibull Scale (c) Parameter: ', num2str(pd.a)]);  % Weibull skala parameter
disp(['Weibull Shape (k) Parameter: ', num2str(pd.b)]);  % Weibull form parameter

% Definer verdier for vindhastighet for å beregne PDF
wind_speed_values = linspace(min(all_wind_speeds), max(all_wind_speeds), 100);

% Beregn PDF-verdier
pdf_values = pdf(pd, wind_speed_values);

% Plot histogram av de observerte vindhastighetene
figure;
histogram(all_wind_speeds, 'Normalization', 'pdf', 'BinWidth', 1); % Juster 'BinWidth' etter behov
hold on; % Hold på den nåværende plotten for å legge til Weibull PDF

% Plot Weibull-distribusjonen
plot(wind_speed_values, pdf_values, 'LineWidth', 2, 'Color', 'r');
xlabel('Wind Speed (m/s)');
ylabel('Probability Density');
title('Histogram & Weibull Distribution for Wind Speed');
legend('Observed Data', 'Weibull PDF');
grid on;
hold off;
