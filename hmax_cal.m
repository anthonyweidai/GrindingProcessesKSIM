function hmax_cal()
rpm=3000;               %wheel spinning speed, round/min
ds=30e3;                %diameter of a grd wheel, um
vw=100e3;               %feed speed, um/min
vw=vw/60;
vs=floor(ds*pi*rpm/60); %grd wheel line speed, um/s
a=10;                    %input('R_m2dgmax:');
L=50;                   %spacing um 
hmax=2*L*(vw/vs)*(a/ds)^0.5

end