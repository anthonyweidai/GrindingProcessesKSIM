function read_report
filename='w3batch_1_premise';
testlist = readtable([filename '.csv']);
testlist = table2array(testlist(:,2:end));
num_cycle = 5;
c_i = 0;
mat_rep=[];
for t_i = 1:num_cycle:size(testlist,1)
    % columns: 1-no; 3-angle; 5-ggap; 6-rgap; 16-Ra; 17-C; 18-Fn; 19-Ft
    %h_angle=testlist(t_i,3);
    vw=testlist(t_i,num_cycle);
%     h_rgap=testlist(t_i,6);
    m_Ra=testlist(:,14);
    m_rs_Ra=testlist(:,15);
    m_rs_Rz=testlist(:,16);
    m_Fn=testlist(:,18);
    m_Ft=testlist(:,19);
%     std_Ra=std(testlist(t_i:t_i+num_cycle-1,16));
%     std_C=std(testlist(t_i:t_i+num_cycle-1,17));
%     std_Fn=std(testlist(t_i:t_i+num_cycle-1,18));
%     std_Ft=std(testlist(t_i:t_i+num_cycle-1,19));
%     mat_rep=[mat_rep; h_angle,h_ggap,h_rgap,m_Ra,m_C,m_Fn,m_Ft,std_Ra,std_C,std_Fn,std_Ft];
    % afterwards, 4-Ra...
end
% writematrix(mat_rep,[filename '-r.csv'])
ang = 15:15:75;
g_gap = 1;
[ANG,GGAP]=meshgrid(ang,g_gap);

Ra_report = reshape(m_Ra,[length(g_gap),length(ang)]);
figure;
surf(ANG,GGAP,Ra_report);

Ra_report = reshape(m_rs_Ra,[length(g_gap),length(ang)]);
figure;
surf(ANG,GGAP,Ra_report);

Ra_report = reshape(m_Fn,[length(g_gap),length(ang)]);
figure;
surf(ANG,GGAP,Ra_report);

Ra_report = reshape(m_Ft,[length(g_gap),length(ang)]);
figure;
surf(ANG,GGAP,Ra_report);