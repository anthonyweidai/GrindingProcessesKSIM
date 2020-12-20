function read_report
filename='EFFECTOFDIST';
testlist = table2array(readtable([filename '.csv']));
num_cycle = 10;
c_i = 0;
mat_rep=[];
for t_i = 1:10:size(testlist,1)
    % columns: 1-no; 3-angle; 5-ggap; 6-rgap; 16-Ra; 17-C; 18-Fn; 19-Ft
    h_angle=testlist(t_i,3);
    h_ggap=testlist(t_i,5);
    h_rgap=testlist(t_i,6);
    m_Ra=mean(testlist(t_i:t_i+9,16));
    m_C=mean(testlist(t_i:t_i+9,17));
    m_Fn=mean(testlist(t_i:t_i+9,18));
    m_Ft=mean(testlist(t_i:t_i+9,19));
    std_Ra=std(testlist(t_i:t_i+9,16));
    std_C=std(testlist(t_i:t_i+9,17));
    std_Fn=std(testlist(t_i:t_i+9,18));
    std_Ft=std(testlist(t_i:t_i+9,19));
    mat_rep=[mat_rep; h_angle,h_ggap,h_rgap,m_Ra,m_C,m_Fn,m_Ft,std_Ra,std_C,std_Fn,std_Ft];
    % afterwards, 4-Ra...
end
% writematrix(mat_rep,[filename '-r.csv'])
ang = 20:10:80;
g_gap = 1:5;
[ANG,GGAP]=meshgrid(ang,g_gap);
Ra_report = reshape(mat_rep(:,4),[length(g_gap),length(ang)]);
figure;
surf(ANG,GGAP,Ra_report);

