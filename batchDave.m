set(0,'defaultfigurecolor',[1 1 1])
if isfile(['batch\\' 'errorReport.csv'])
    delete(['batch\\' 'errorReport.csv']);
end
Cycle = 1;
% Cycle = 4:5;
% %%
% Shape = 1;
% FOI = 'Default';
% InterestingParam = 0.7;
% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
%%%%%%%%%%%%%% The following parameter sets' default param are removed
%%
Shape = 1;
FOI = 'Edges';
InterestingParam1 = [3 5 7 9 15 25];
InterestingParam2 = [0.2 0.4 0.6 0.8];
FOIEdges(Cycle, FOI, Shape, InterestingParam1, InterestingParam2);
% %%
% Shape = 1;
% FOI = 'FilletMode';
% InterestingParam = [1 2];
% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
% %%
% Shape = 1;
% FOI = 'Sigmarg';
% InterestingParam = [0.02 0.04 0.06 0.08 0.1];
% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
% %%
% Shape = 1;
% FOI = 'Sigmah';
% InterestingParam = [0.01 0.02 0.03 0.04 0.05];
% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
% %%
% Shape = 2;
% FOI = 'EllipsoidRarea';
% %%%%%% InterestingParam = [1 1.5 2 2.5];
% InterestingParam = [1];
% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
% %%
% Shape = 3;
% FOI = 'Xi';
% %%%%%% InterestingParam = [0.5 0.55 0.6 0.65 0.7];
% InterestingParam = [0.55];
% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%
% FOI = 'theta';
% InterestingParam = [10 20 30 40 50 55 65 70 75 80];
% %%%%%% InterestingParam = [20 30 40 50 70];
% FOISepParam(Cycle, FOI, InterestingParam);
% %%
% FOI = 'RowGap';
% InterestingParam = [0.5 0.75 1.5 2];
% %%%%%% InterestingParam = [0.75 1.5 2];
% FOISepParam(Cycle, FOI, InterestingParam);
% %% 
% FOI = 'SepGap';
% InterestingParam = [0.25 0.4 0.6 0.75 1];
% %%%%%% InterestingParam = [0.4 0.6 0.75];
% FOISepParam(Cycle, FOI, InterestingParam);
% %%
% FOI = 'KDev';
% InterestingParam = [0.02 0.06 0.1 0.2 0.3];
% %%%%%% InterestingParam = [0.2 0.4 0.6 0.8 1 3];
% FOISepParam(Cycle, FOI, InterestingParam); 


%%
%%%%%%% Shape = 1;
%%%%%%% FOI = 'Omega';
% %%%%%%% InterestingParam = [3 4 5 6 8 9 10 15 20 25];
%%%%%%% InterestingParam = [3 5 9 15 25];
%%%%%%% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
%%
%%%%%%% Shape = 1;
%%%%%%% FOI = 'FrustumRarea';
%%%%%%% InterestingParam = [0.2 0.3 0.4 0.5 0.6 0.8 0.9];
% %%%%%%% InterestingParam = [0.03 0.06 0.12 0.15 0.2];
%%%%%%% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
%%
%%%%%%% Shape = 1;
%%%%%%% FOI = 'RHeightSize';
%%%%%%% InterestingParam = [0.7 0.9 1 1.2 1.5]; % without default, RAMode = 1
%%%%%%% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
%% 
%%%%%%% FOIConeAngle(Cycle);
%%
%%%%%%% Shape = 1;
%%%%%%% FOI = 'Trimmingh';
%%%%%%% InterestingParam = [0 0.3 0.6 0.9 1.5 2];
%%%%%%% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
%%
%%%%%%% Shape = 1;
%%%%%%% FOI = 'SigmaSkew'; % Skew of the grains
%%%%%%% InterestingParam = [0 0.02 0.04 0.06 0.08 0.1 0.15 0.2];
%%%%%%% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);

% system('shutdown -s')