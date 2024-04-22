function [nWorker] = setparpool(parallel, nWorker)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for parpool management         %
% (parallel computation on several cores  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parallel settings
% Anz. Worker= Anz. CPUs des Rechners. Wird automatisch erkannt.
%--------------------------------------------------------------------------
core_info = evalc('feature(''numcores'')');
core_info(end-2);
worker = str2double(['int32(' core_info(end-2) ')']);
%--------------------------------------------------------------------------
% Lizenz abfragen, 1=verfuegbar 0=nicht.
% Dieser Befehl holt die Lizenz bereits beim ausfuehren!
S=license('checkout','Distrib_Computing_Toolbox');
% Wenn verf. wird parallelpool gestartet
% Mit S=0 kann parallel processing manuell abgeschaltet wer
if parallel==0
nWorker=1;
S=0;
delete(gcp('nocreate'));
end
%--------------------------------------------------------------------------
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if S==1
    if isempty(poolobj)
        if nWorker==0 %in Input schreiben
            parpool;
            poolobj = gcp('nocreate'); % If no pool, do not create new one.
            nWorker=poolobj.NumWorkers;
        else%Im input workers definieren nCPU/nWorker -> 0 so viel wie geht -> mit Zahl dann die Zahl
            parpool(nWorker);
        end
    else 
            delete(gcp('nocreate'));
        if nWorker==0 %in Input schreiben
            parpool;
            poolobj = gcp('nocreate'); % If no pool, do not create new one.
            nWorker=poolobj.NumWorkers;
        else%Im input workers definieren nCPU/nWorker -> 0 so viel wie geht -> mit Zahl dann die Zahl
            parpool(nWorker);
        end
    end
    
    
    spmd
        warning('off','all');
        warning;
    end
    %--------------------------------------------------------------------------
    % Wenn keine Lizenz vorhanden ist, wird kein parallelpool gestartet
    % 0 Worker bewirkt, dass die parfor-Schleife sequentiell ausgefuehrt wird.
    %--------------------------------------------------------------------------
else
    worker=0;
end
%--------------------------------------------------------------------------
% ENDE PARALLEL SETTINGS