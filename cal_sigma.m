function [sigma_maxps,sigma_maxoyps,sigma_mayozps]=cal_sigma(sigma_11,sigma_21,sigma_22,sigma_31,sigma_32,sigma_33)
sigma_d=[sigma_11,sigma_21,sigma_31;sigma_21,sigma_22,sigma_32;sigma_31,sigma_32,sigma_33];
sigma_xoy=sigma_d(1:2,1:2);
sigma_yoz=sigma_d(2:3,2:3);
%-----------max pricipal stress-----------------------
sigma_d(isnan(sigma_d))=0;%turn all NaN into 0.
sigma_maxps=0;
[V,D]=eigenshuffle(sigma_d);
gama_1=D(1,1);
gama_2=D(2,1);
gama_3=D(3,1);
if max([gama_1,gama_2,gama_3])==gama_1
    sigma_maxps=D(1,1);
    maxps_x=V(1,1);
    maxps_y=V(2,1);
    maxps_z=V(3,1);
else
    if max([gama_1,gama_2,gama_3])==gama_2
        sigma_maxps=D(2,2);
        maxps_x=V(1,2);
        maxps_y=V(2,2);
        maxps_z=V(3,2);
    else
        if max([gama_1,gama_2,gama_3])==gama_3
            sigma_maxps=D(3,3);
            maxps_x=V(1,3);
            maxps_y=V(2,3);
            maxps_z=V(3,3);
        end
    end
end
%--------xoy--inplane--principal--stress---------
sigma_xoy(isnan(sigma_xoy))=0;%turn all NaN into 0.
sigma_maxoyps=0;
[V,D]=eigenshuffle(sigma_xoy);
gama_1=D(1,1);
gama_2=D(2,1);
if max([gama_1,gama_2])==gama_1
    sigma_maxoyps=D(1,1);
    maxoyps_x=V(1,1);
    maxoyps_y=V(2,1);
else
    if max([gama_1,gama_2])==gama_2
        sigma_maxoyps=D(2,2);
        maxoyps_x=V(1,2);
        maxoyps_y=V(2,2);
    end
end
%--------yoz--inplane--principal--stress---------
sigma_yoz(isnan(sigma_yoz))=0;%turn all NaN into 0.
sigma_mayozps=0;
[V,D]=eigenshuffle(sigma_yoz);
gama_1=D(1,1);
gama_2=D(2,1);
if max([gama_1,gama_2])==gama_1
    sigma_mayozps=D(1,1);
    mayozps_y=V(1,1);
    mayozps_z=V(2,1);
else
    if max([gama_1,gama_2])==gama_2
        sigma_mayozps=D(2,2);
        mayozps_y=V(1,2);
        mayozps_z=V(2,2);
    end
end
end
