function comprehensiveEvaluation(Cycle, WheelType, FOIStorage)
%% Comprehensively evaluate grinding performance
NewSubfolder = 'MeanAnalysis/Commenting'; % For mean analysis
if exist(NewSubfolder,'dir')
    delete([NewSubfolder '/*'])
end
    
for i = 1:length(FOIStorage)
    FOI = char(FOIStorage(i));
    InputField = initInputField(FOI);
    % OutputField = {'Ra' 'FnSteady' 'FtSteady' 'MaxStress' 'MeanStress' 'CGrits'};
    
    [xName, ~] = labelsName(FOI, InputField, []);
    
    FilePath = ['MeanAnalysis/' FOI];
    %%
    if length(WheelType) == 1 || strcmp(FOI, 'Edges')
        singleEvaluation(Cycle, WheelType, FilePath, FOI, InputField, xName);
    elseif length(WheelType) == 2
        mixedEvaluation(Cycle, WheelType, FilePath, FOI, InputField, xName);
    end
end