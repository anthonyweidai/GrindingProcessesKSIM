function [WCutting, WInactive, WCGrits, WRa, WF, WMaxStress, CR] = weightSettingUp(MaterialType)
%% Setting up weight of interesting result values
if MaterialType == 1 % rough grinding
    WRa = 0.6;
    WForce = 0.2;
    WStress = 0.2;
elseif MaterialType == 2 % brittle material grinding
    WRa = 0.5;
    WForce = 0.1;
    WStress = 0.4;
elseif MaterialType == 3 % Plastic material grinding
    WRa = 0.5;
    WForce = 0.4;
    WStress = 0.1;
end
% if MaterialType == 1 % rough grinding
%     WRa = 0.6;
%     WForce = 0.2;
%     WStress = 0.2;
% elseif MaterialType == 2 % brittle material grinding
%     WRa = 0.4;
%     WForce = 0.2;
%     WStress = 0.4;
% elseif MaterialType == 3 % Plastic material grinding
%     WRa = 0.4;
%     WForce = 0.4;
%     WStress = 0.2;
% end
%%
WeightVector = [WRa WForce WStress];
W12 = weightDegree(WeightVector(1), WeightVector(2));
W13 = weightDegree(WeightVector(1), WeightVector(3));
W23 = weightDegree(WeightVector(2), WeightVector(3));
ComparisonMatrix = [1 W12 W13
    1/W12	1 W23
    1/W13	1/W23 1];
%%
[w, CR] = APHSolver(ComparisonMatrix);

WRa = w(1);
WForce = w(2);
WStress = w(3);
WCutting = 0;
WInactive = 0;
WCGrits = 0;

WF = WForce;
WMaxStress = WStress;
end

%%%%%%%%%%% 2021/02
% WCGrits = 0.1;
% WCutting = 0.1;
% WInactive = 0.2;
% if MaterialType == 1 % rough grinding
%     WRa = 0.6;
%     WForce = 0.2;
%     WStress = 0.2;
% elseif MaterialType == 2 % brittle material grinding
%     WRa = 0.5;
%     WForce = 0.2;
%     WStress = 0.3;
% elseif MaterialType == 3 % Plastic material grinding
%     WRa = 0.5;
%     WForce = 0.3;
%     WStress = 0.2;
% end
% %%
% WeightVector = [WRa WForce WStress WCutting WInactive WCGrits];
% W12 = weightDegree(WeightVector(1), WeightVector(2));
% W13 = weightDegree(WeightVector(1), WeightVector(3));
% W14 = weightDegree(WeightVector(1), WeightVector(4));
% W15 = weightDegree(WeightVector(1), WeightVector(5));
% W16 = weightDegree(WeightVector(1), WeightVector(6));
% W23 = weightDegree(WeightVector(2), WeightVector(3));
% W24 = weightDegree(WeightVector(2), WeightVector(4));
% W26 = weightDegree(WeightVector(2), WeightVector(6));
% W25 = weightDegree(WeightVector(2), WeightVector(5));
% W34 = weightDegree(WeightVector(3), WeightVector(4));
% W35 = weightDegree(WeightVector(3), WeightVector(5));
% W36 = weightDegree(WeightVector(3), WeightVector(6));
% W45 = weightDegree(WeightVector(4), WeightVector(5));
% W46 = weightDegree(WeightVector(4), WeightVector(6));
% W56 = weightDegree(WeightVector(5), WeightVector(6));
% ComparisonMatrix = [1 W12 W13 W14 W15 W16
%     1/W12	1 W23 W24 W25 W26
%     1/W13	1/W23 1	W34 W35 W36
%     1/W14	1/W24 1/W34 1 W45 W46
%     1/W15	1/W25 1/W35 1/W45 1 W56
%     1/W16	1/W26 1/W36 1/W45 1/W56 1];
% %%
% [w, CR] = APHSolver(ComparisonMatrix);
% 
% WRa = w(1);
% WForce = w(2);
% WStress = w(3);
% WCutting = w(4);
% WInactive = w(5);
% WCGrits = w(6);
% 
% WFn = WForce;
% WMaxStress = WStress;