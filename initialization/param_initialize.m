function [sepparam, geoparam] = param_initialize(sepparam, geoparam)
%% Initialize input variables
%% seperation parameters
sepparam.wheel_type(~isfield(sepparam,'wheel_type')) = 2;   % 1-random; 2-tgw
if sepparam.wheel_type == 2
    sepparam.LS_mode(~isfield(sepparam,'LS_mode')) = 0;
    if sepparam.LS_mode == 1
        sepparam.theta(~isfield(sepparam,'theta')) = 60;
        sepparam.RowGap(~isfield(sepparam,'RowGap')) = 150;
        sepparam.SaveGap(~isfield(sepparam,'SaveGap')) = 100;
    end
elseif sepparam.wheel_type == 3
    sepparam.theta(~isfield(sepparam,'theta')) = 80;   % line tilt angle:30 40 50 60 70 80
    sepparam.SepGap(~isfield(sepparam,'SepGap')) = 0.5; % column gap: 0.5,1,3,5
    sepparam.RowGap(~isfield(sepparam,'RowGap')) = 3;   % row gap: 1,3,5,7
    sepparam.k_dev(~isfield(sepparam,'k_dev')) = 0;    % position deviation para: 1,3,5,7
end
%% geometrical parameters
geoparam.shape(~isfield(geoparam,'shape')) = 1;
if geoparam.shape == 1
    geoparam.trim_h(~isfield(geoparam,'trim_h')) = 0;
    geoparam.omega(~isfield(geoparam,'omega')) = 3;
    geoparam.h2w_ratio(~isfield(geoparam,'h2w_ratio')) = 1;
    geoparam.Rarea(~isfield(geoparam,'Rarea')) = 0.5;
    geoparam.Rsigma(~isfield(geoparam,'Rsigma')) = 0;
    geoparam.RA_mode(~isfield(geoparam,'RA_mode')) = 1;
    geoparam.sigmasw(~isfield(geoparam,'sigmasw')) = 0;
    geoparam.fillet_mode(~isfield(geoparam,'fillet_mode')) = 0;
elseif geoparam.shape == 3
    geoparam.xi(~isfield(geoparam,'xi')) = 0;
end
geoparam.sigmah(~isfield(geoparam,'sigmah')) = 0;
end
