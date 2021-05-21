function [xName, yName] = labelsName(FOI, InputField, OutputField)
%% Turn field's name into thesis symbol's name
%% x axis label
if strcmp(InputField,'RHeightSize')
    xName = 'R_h';
elseif strcmp(InputField,'Trimmingh')
    xName = 'h_{trim}/\mum';
elseif strcmp(InputField,'Sigmah')
    xName = '\sigma_h/\mum';
elseif strcmp(InputField,'Sigmarg')
    xName = '\sigma_{r_g}/\mum';
elseif strcmp(InputField,'SigmaSkew')
    xName = '\sigma_v/\mum';
elseif strcmp(InputField,'Xi')
    xName = '\xi';
elseif strcmp(InputField,'theta')
    xName = '\theta_d/^0';
elseif strcmp(InputField,'RowGap')
    xName = 'D_c/\mum';
elseif strcmp(InputField,'SepGap')
    xName = 'D_r/\mum';
elseif strcmp(InputField,'KDev')
    xName = 'K_{dev}/\mum';
elseif strcmp(FOI,'FrustumRarea')
    xName = 'R_{area}';
elseif strcmp(FOI,'EllipsoidRarea')
    xName = 'R_{area}^,';
elseif strcmp(InputField,'FilletMode')
    xName = '磨损状态';
elseif strcmp(InputField,'Omega')
    xName = '\omega/条';
else
    xName = InputField;
end
%% y axis label
if strcmp(OutputField,'FnSteady')
    yName = 'F_n/N';
elseif strcmp(OutputField,'FtSteady')
    yName = 'F_t/N';
elseif strcmp(OutputField,'MaxStress')
    yName = '\sigma_{max}/GPa';
elseif strcmp(OutputField,'MeanStress')
    yName = '\sigma_{mean}/GPa';
elseif strcmp(OutputField,'CGrits')
    yName = 'C_r/(个/mm^2)';
elseif strcmp(OutputField,'Ra')
    yName = 'Ra/\mum';
elseif strcmp(OutputField,'proh')
    yName = 'h/\mum';
elseif strcmp(OutputField,'rg')
    yName = 'r_g/\mum';
elseif strcmp(OutputField,'UCT') || strcmp(OutputField,'uct') 
    yName = 'h_m/\mum';
else
    yName = OutputField;
end
end