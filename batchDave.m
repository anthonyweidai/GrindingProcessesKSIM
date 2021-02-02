set(0,'defaultfigurecolor',[1 1 1])
createFolder();
if isfile(['batch\\' 'errorReport.csv'])
    delete(['batch\\' 'errorReport.csv']);
end
%%
cycle = 1;
parallel_mode = 0;
%% test
FOI_edgestemp(cycle, parallel_mode);
%%
% FOI_edges(cycle, parallel_mode);
% FOI_ConeAngle(cycle, parallel_mode);
% FOI_sigmasw(cycle, parallel_mode); 
% FOI_FruRarea(cycle, parallel_mode)
% 
% FOI_ELSRarea(cycle, parallel_mode);
% 
% FOI_xi(cycle, parallel_mode);

% FOI_sigmah(cycle, parallel_mode);
% FOI_Rsigma(cycle, parallel_mode);

