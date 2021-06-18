set(0,'defaultfigurecolor',[1 1 1])
if isfile(['batch\\' 'errorReport.csv'])
    delete(['batch\\' 'errorReport.csv']);
end
% %%%%%%%%%%%%%% The following parameter sets' default param are removed
% %%
% Cycle = 2:3;
% Shape = 1;
% FOI = 'Edges';
% InterestingParam1 = 15;
% InterestingParam2 = [0.6 0.8];
% FOIEdges(Cycle, FOI, Shape, InterestingParam1, InterestingParam2);
% 
% Cycle = 2;
% Shape = 1;
% FOI = 'Edges';
% InterestingParam1 = [9];
% InterestingParam2 = [0.6];
% FOIEdges(Cycle, FOI, Shape, InterestingParam1, InterestingParam2);
% %%
% Cycle = 3;
% Shape = 1;
% FOI = 'FilletMode';
% InterestingParam = [1];
% FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
%%
Cycle = 1:4;
Shape = 1;
FOI = 'Sigmah';
InterestingParam = [0.01 0.02 0.03 0.04 0.05];
FOIGeoParam(Cycle, FOI, Shape, InterestingParam);
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% 
% Cycle = 1:2;
% FOI = 'SepGap';
% InterestingParam = [0.75];
% FOISepParam(Cycle, FOI, InterestingParam);
% 
% Cycle = 3;
% FOI = 'SepGap';
% InterestingParam = [0.25 0.4];
% FOISepParam(Cycle, FOI, InterestingParam);