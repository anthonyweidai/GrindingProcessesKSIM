set(0,'defaultfigurecolor',[1 1 1])
batum = 4; % enter a different batch number on each research topic
Rasave = [0.1]; %0,0.25,0.5,0.75,0.95
shape = 1; % 1-trapezoid&pyramid
sigmah=0.0;
sigmasw=0.0;
i_run=0;
for omega = 8 %3:3:9
    for wheel_type = 2
%         for sigmah= [0.02 0.05 0.1]
%             for sigmasw =  [0.02 0.05 0.1]
                if wheel_type == 1
                    for rc = 1:length(Rasave)
                        Rarea = Rasave(rc);
                        GrdProcess3(cycle,0,0,0,0,shape,omega,wheel_type,Rarea,batum,sigmah,sigmasw);
                    end
                    continue
                end
                for RowGap = 1:1:5%1:0.5:5
                    for theta = 20:10:80
                     %1 2 
                        for k_dev = [0] %[0,0.5,1]
                            for GritGap = [0.5]
                                for rc = 1:length(Rasave)
                                    Rarea = Rasave(rc);
                                    for cycle = 3
%                                         i_run=i_run+1;
%                                         num_runs=length(cycle)*length(theta)*length(RowGap)*length(GritGap)*length(k_dev)*length(Rarea);
%                                         disp([num2str(i_run) '/' num2str(num_runs)])
                                        GrdProcess3(cycle,theta,RowGap,GritGap,k_dev,shape,omega,wheel_type,Rarea,batum,sigmah,sigmasw);
                                    end
                                end
                            end
                        end
                    end
                end
%             end
%         end
    end
end
