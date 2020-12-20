set(0,'defaultfigurecolor',[1 1 1])
batum = 3; % enter a different batch number on each research topic
Rasave = [0,0.25,0.5,0.75,0.95]; %0,0.25,0.5,0.75,0.95
Rasave = 0:0.1:0.8;
shape = 1; % 1-trapezoid&pyramid
sigmah=0;
sigmasw=0;
for omega = 6
    for wheel_type = 2
%          for sigmah= [0.1] %0.02 0.05 
%              for sigmasw =  [0.02 0.05 0.1]
                if wheel_type == 1
                    for rc = 1:length(Rasave)
                        Rarea = Rasave(rc);
                        GrdProcess3(0,0,0,shape,omega,wheel_type,Rarea,batum,sigmah,sigmasw);
                    end
                    continue
                end
                for theta = [40 60 80] %30 45 60
                    for RowGap = [3] %1 2 
                        for k_dev = 0 %[0,0.5,1]
                            for rc = 1:length(Rasave)
                                Rarea = Rasave(rc);
                                GrdProcess3(theta,RowGap,k_dev,shape,omega,wheel_type,Rarea,batum,sigmah,sigmasw);
                            end
                        end
                    end
                end
%              end
%          end
    end
end