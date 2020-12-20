function get_stress()
Fn=0.001;
k_Fn=Fn/0.001;
store_stress(Fn)
end

function store_stress(Fn)
[h,a,b,psi,B,lamda]=plas_cal(0);
Fn=0.001;
x=0;
yi=0;zi=0;
sigma_11=[];sigma_12=[];sigma_13=[];sigma_22=[];sigma_23=[];sigma_33=[];
for y = -3:0.1:3
    yi=yi+1;
    for z = 0:-0.1:-5
        zi=zi+1;
        sigma_d=get_sigma(x,y,z,1,Fn);
        sigma_11(yi,zi)=sigma_d(1,1);
        sigma_22(yi,zi)=sigma_d(2,2);
        sigma_33(yi,zi)=sigma_d(3,3);
        sigma_21(yi,zi)=sigma_d(2,1);
        sigma_31(yi,zi)=sigma_d(3,1);
        sigma_32(yi,zi)=sigma_d(3,2);
    end
end
writematrix([sigma_11;sigma_12;sigma_13;sigma_22;sigma_23;sigma_33],'blisterstress.csv');
end

function sigma_d=get_sigma(x,y,z,field,Fn)
%-all parameters-----------------------------------------------------------
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
end