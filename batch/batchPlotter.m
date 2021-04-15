function batchPlotter(SavePath, Cycle, WheelType, FOI, InputField, OutputField, Flag)
%% Plotter
PlotFig1 = figure(1);
[xName, yName] = labelsName(FOI, InputField, OutputField);
%%
FileName = [SavePath '-Total' num2str(Cycle) 'Wheel3' '.csv'];
T1 = readtable(FileName,'PreserveVariableNames',1);
% FOIHandler = sortrows(T1,InputField);
x = table2array(T1(:,InputField));
y = table2array(T1(:,OutputField));
figure(1);
plot(x,y,'r');
%%
if length(WheelType) >= 2
    FileName = [SavePath '-Total' num2str(Cycle) 'Wheel2' '.csv'];
    T2 = readtable(FileName,'PreserveVariableNames',1);
    % FOIHandler = sortrows(T2,InputField);
    x2 = table2array(T2(:,InputField));
    y2 = table2array(T2(:,OutputField));
    EnhanceRatio = y./y2;
    hold on;
    plot(x2,y2,'b--');
    legend('有序排布','无序排布')
end
%%
% axis equal
xlabel(xName); ylabel(yName);
FileName = [SavePath '/' OutputField '-' InputField];
savefig([FileName '.fig']);
% saveas(PlotFig1, [FileName '.svg']);
print([FileName '.jpg'], '-djpeg' );
close(PlotFig1);
%%
if Flag == 0
    %%
    PlotFig2 = figure(2);
    y1 = table2array(T1(:,'Cutting/%'));
    y2 = table2array(T1(:,'Plughing/%'));
    y3 = table2array(T1(:,'Rubbing/%'));
    y4 = table2array(T1(:,'Inactive/%'));
    plot(x,y1,'r-',x,y2,'b-',x,y3,'y-',x,y4,'k-');
    
    if length(WheelType) >= 2
        y1 = table2array(T2(:,'Cutting/%'));
        y2 = table2array(T2(:,'Plughing/%'));
        y3 = table2array(T2(:,'Rubbing/%'));
        y4 = table2array(T2(:,'Inactive/%'));
        hold on
        plot(x,y1,'r--',x,y2,'b--',x,y3,'y--',x,y4,'k--');
        % legend('Cutting','Plughing','Rubbing','Cutting','Plughing','Rubbing')
        legend('P_c-有序','P_p-有序','P_r-有序','P_i-有序',...
            'P_c-无序','P_p-无序','P_r-无序','P_i-无序')
    else
        % legend('Cutting','Plughing','Rubbing','Inactive')
        legend('P_c','P_p','P_r','P_i')
    end
    
    xlabel(xName); ylabel('接触状态/%');
    FileName = [SavePath '/' InputField '-' 'persent'];
    savefig([FileName '.fig']);
    % saveas(PlotFig2, [FileName '.svg']);
    print([FileName '.jpg'], '-djpeg' );
    close(PlotFig2);
    %%
    if WheelType == 3
        PlotFig3 = figure(3);
        y1 = table2array(T1(:,'Cutting'));
        y2 = table2array(T1(:,'Plughing'));
        y3 = table2array(T1(:,'Rubbing'));
        y4 = table2array(T1(:,'Inactive'));
        NumGrits = y1 + y2 + y3 + y4;
        [ColumnsNum, RowsNum, maxRowsNum] = TGWColunmsNum(x,NumGrits);
        plot(x,ColumnsNum,'r-',x,maxRowsNum,'b-');
        
        % legend('Row value','Column value')
        legend('磨粒列数','磨粒最大行数')
        
        xlabel(xName); ylabel('数量/排');
        FileName = [SavePath '/' InputField '-' 'RowColumnNum'];
        savefig([FileName '.fig']);
        % saveas(PlotFig3, [FileName '.svg']);
        print([FileName '.jpg'], '-djpeg' );
        close(PlotFig3);
    end
end
end