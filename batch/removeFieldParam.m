function RemoveInfo = removeFieldParam(BackupMode, CommentingMode)
%% Retrun removed field's parameters
DoneMode = 1;
if BackupMode == 1
    %% Re-run set of parameters
    if DoneMode == 0
        RemoveInfo3.FOI = 'theta';
        RemoveInfo3.Field = 'theta';
        RemoveInfo3.Values = [90];
        RemoveInfo4.FOI = 'FrustumRarea';
        RemoveInfo4.Field = 'Rarea';
        RemoveInfo4.Values = [0.8 0.9];
        RemoveInfo = [RemoveInfo3 RemoveInfo4];
    else
        RemoveInfo = [];
    end
elseif CommentingMode == 0
    %% Ignore set of existed parameters
    %     RemoveInfo1.FOI = 'Sigmarg';
    %     RemoveInfo1.Field = 'Sigmarg';
    %     RemoveInfo1.Values = [0.15 0.2 0.3];
    %     RemoveInfo2.FOI = 'EllipsoidRarea';
    %     RemoveInfo2.Field = 'Rarea';
    %     RemoveInfo2.Values = [0.4 0.5 0.6 0.65 0.7 0.75 0.8 0.9];
    %     RemoveInfo3.FOI = 'theta';
    %     RemoveInfo3.Field = 'theta';
    %     RemoveInfo3.Values = [10 55 65 75 80];
    %     RemoveInfo4.FOI = 'Edges';
    %     RemoveInfo4.Field = 'FilletMode';
    %     RemoveInfo4.Values = 1;
    %     RemoveInfo7.FOI = 'RowGap';
    %     RemoveInfo7.Field = 'RowGap';
    %     RemoveInfo7.Values = [0.5];
    %     RemoveInfo8.FOI = 'SepGap';
    %     RemoveInfo8.Field = 'SepGap';
    %     RemoveInfo8.Values = [0.25 1];
        RemoveInfo = [];
elseif CommentingMode == 1
    %% Ignore set of existed parameters (aleady scaled)
    %     RemoveInfo1.FOI = 'theta';
    %     RemoveInfo1.Field = 'theta';
    %     RemoveInfo1.Values = [0 90];
    %     RemoveInfo2.FOI = 'Sigmah';
    %     RemoveInfo2.Field = 'Sigmah';
    %     RemoveInfo2.Values = [1 1.5 2];
    %     RemoveInfo = [RemoveInfo1 RemoveInfo2];
    RemoveInfo = [];
end
end