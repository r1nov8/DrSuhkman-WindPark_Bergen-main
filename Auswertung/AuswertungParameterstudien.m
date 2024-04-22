%% Plot RotorRes
load("Auswertung\Master_Parameterstudies\RotorPointstudyResults.mat");
figure(3)
plot(Rotorstudy.RotorRes,Rotorstudy.TotalPower/1000000)
hold on
yyaxis right
plot(Rotorstudy.RotorRes,Rotorstudy.Time)
xlabel('Number of Computation Points per Rotor')
yyaxis left
ylabel('Total Power [MW]')
yyaxis right
ylabel('Computation time [s]')

%% Plot UcPoints
load("Auswertung\Master_Parameterstudies\UcPointstudyResults.mat");
figure(2)
plot(linspace(10,1000),UcStudy.TotalPower/1000000)
hold on
yyaxis right
plot(linspace(10,1000),UcStudy.Time)
xlabel('Number of Computation Points per Rotor')
yyaxis left
ylabel('Total Power [MW]')
yyaxis right
ylabel('Computation time [s]')

%% Plot TerminationStudy
load("Auswertung\Master_Parameterstudies\TerminationStudy.mat");
figure(3)
semilogx(TerminationStudy.sigmaMIN,TerminationStudy.TotalPower/1000000)
set(gca, 'xdir','reverse')
hold on
yyaxis right
semilogx(TerminationStudy.sigmaMIN,TerminationStudy.Time)
semilogx(TerminationStudy.sigmaMIN,TerminationStudy.Iterations)
xlabel('Sigma at')
yyaxis left
% ylabel('Total Power [MW]')
yyaxis right
% ylabel('Computation time [s]')
legend('Total Power [MW]', 'Computation Time [s]', 'Number of Iterations [-]')