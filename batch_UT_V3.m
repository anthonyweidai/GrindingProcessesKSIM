set(0,'defaultfigurecolor',[1 1 1])
create_folder();
%%
batnum = 1;
parallel_mode = 1;
% FOI_edges(batnum, parallel_mode);
FOI_ConeAngle(batnum, parallel_mode);
FOI_sigmasw(batnum, parallel_mode);

% FOI_ELSRarea(batnum, parallel_mode);

% FOI_xi(batnum, 0); %% top area calculation 

% FOI_sigmah(batnum, parallel_mode);
% FOI_Rsigma(batnum, 0);