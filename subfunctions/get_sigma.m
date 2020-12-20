function [sigma_11,sigma_22,sigma_33,sigma_21,sigma_32,sigma_31]=get_sigma(x,y,z,field,Fn)
%-all parameters-----------------------------------------------------------
% fraction=0.103; %(ww,2016) Volumn contraction of BK7
% E=83; %GPa young's module E
% H=7.6; %GPa Vickers hardness H 
% % a=1; %plastic zone diameter@@@@@@@@@@@@@@@@@@@@@@@@
% % %pi=3.1415926;%pi
% mu=0.203; %(Gu,2011)possion ratio
%  psi=40/180*pi; %psi
%  lamda=pi/( 4*tan(psi) ); %Ft:Fn=lamda 
% % %The relationship between h and a(B)/Ft/Fn
% B=fraction*E*3*cot(psi)/(4*pi^2*H*(1+mu)*(1-2*mu)); %Parameter B
%Fn=H*pi*a;%(mN)
%Ft=lamda*Fn;
[h,a,b,psi,B,lamda]=plas_cal(0);
%-fields-------------------------------------------------------------------
%-1-blister-field==========================================================
if field==1
    k2=B/Fn;
    sigma_d=getblister(x,y,z,Fn);
    sigma_d=k2*sigma_d;
end
%-2-boussinesq-field=======================================================
if field==2
    sigma_d=getboussinesq(x,y,z,Fn);
end
%-3-cerruti-field==========================================================
if field==3
    sigma_d=getcerruti(x,y,z,Fn);
end
%-4-sc-blister-field=======================================================
if field==4
    sigma_d=1/tan(psi)*(getcerruti(y-a/2,-x,z+a/tan(psi),Fn)+getcerruti(-y-a/2,x,z+a/tan(psi),Fn));
end
%-5-indentation-field======================================================
if field==5
    sigma_d_1=getblister(x,y,z,Fn);
    sigma_d_2=getboussinesq(x,y,z,Fn);
    
    sigma_d=sigma_d_1+sigma_d_2;
end
%-6-scratch-field==========================================================
if field==6
    sigma_d_1=getboussinesq(x,y,z,Fn);
    sigma_d_2=getcerruti(x,y,z,Fn);
    sigma_d_3=getblister(x,y,z,Fn);
    % estimate all field strength and add up
    k0=1;
    k1=lamda; %Ft:Fn=lamda
    k2=B/Fn;%0.1;
%     k1=1.2; %Ft:Fn=lamda
%     k2=0.2;%0.1;
    sigma_d=k0*(sigma_d_1+k1*sigma_d_2)+k2*sigma_d_3;
end
%-6-scratch-field==========================================================
if field==7
    sigma_d_1=getboussinesq(x,y,z,Fn);
    sigma_d_2=getcerruti(x,y,z,Fn);
    sigma_d_3=getblister(x,y,z,Fn);
    sigma_d_4=getcerruti(y-a/2,-x,z+a/tan(psi),Fn)+getcerruti(-y-a/2,x,z+a/tan(psi),Fn);
    % estimate all field strength and add up
    k0=1;
    k1=lamda; %Ft:Fn=lamda
    k2=B/Fn;%0.1;
    k3=1/tan(psi);
%     k1=1.2; %Ft:Fn=lamda
%     k2=0.2;%0.1;
    sigma_d=k0*(sigma_d_1+k1*sigma_d_2)+k2*sigma_d_3+k3*(sigma_d_4);
end
sigma_11=sigma_d(1,1);
sigma_22=sigma_d(2,2);
sigma_33=sigma_d(3,3);
sigma_21=sigma_d(2,1);
sigma_31=sigma_d(3,1);
sigma_32=sigma_d(3,2);
% end
end