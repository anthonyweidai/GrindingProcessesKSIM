function [h,a,b,ratio,B,lamda,Fn]=plas_cal(mode)
%================depth mode=====================
% h=1.724e-06; %um, 1um, scratch depth
% psi_d=40;
% psi=psi_d/180*pi;
% lamda=pi/( 4*tan(psi) ); %Ft:Fn=lamda 
% k_shape=1;
% [E,H,mu,sigma_y,fraction]=get_material(1);
% %
% a=h*tan(psi);
% b=a*(  3*(1-2*mu)/(5-4*mu)+2*3^0.5/(pi*(5-4*mu))*E/sigma_y*cot(psi)  )^0.5;
% B=k_shape^2*fraction*E*3*cot(psi)*a^2/(4*(1+mu)*(1-2*mu)*pi^2); %Parameter B
% %B=fraction*83/(2*pi*tan(psi)*(1+mu)*(1-2*mu));
% ratio=b/a;
% Fn=k_shape*a^2*pi*H;
%==================load mode===========
Fn=1e-3; %mN
psi_rake=35.3;%degree negative rake angle
psi_d=atan(1/cos(psi_rake/180*pi))/pi*180; %degree
psi=psi_d/180*pi; %degree2rad
lamda=pi/( 4*tan(psi) ); %Ft:Fn=lamda 
k_shape=1; %shape parameter, set to 1 as default
k_x=0.7;
[E,H,mu,sigma_y,fraction]=get_material(1);
a=(k_x*(4*Fn/(3^0.5*H))^0.5)/2;
h=a*2/(6^0.5);

b=a*(  3*(1-2*mu)/(5-4*mu)+2*3^0.5/(pi*(5-4*mu))*E/sigma_y*cot(psi)  ).^0.5;
B=k_shape^2*fraction*E*a^2/(2*tan(psi)*(1+mu)*(1-2*mu)*pi); %wang B

ratio=b/a;
%=======================================
k0=1;
k1=lamda; %Ft:Fn=lamda
k2=B/Fn;
if mode==1
    T={'psi(?)' 'E(Pa)' 'H(Pa)' 'mu(1)';psi_d E H mu;'h (m)' 'a (m)' 'b (m)' 'b/a (1)';h a b ratio;'Fn (N)' 'Ft/Fn (1)' 'B' 'B/Fn (1)';Fn k1 B k2}%;'B(ww,2016)' 'B(Jing,2007)' '' '';B1 B '' ''}
end
end
function [E,H,mu,sigma_y,fraction]=get_material(material)
if material ==1 
    %==========bk7================
    E=83*10^9; %Pa, young's module E
    H=7.6*10^9; %Pa Vickers hardness H 
    sigma_y=3.5*10^9; %Pa, yield strength of BK7
    mu=0.203; %(Gu,2011)possion ratio
    fraction=0.103;
else
    %=========silicon?sodalime====
    E=70*10^9; %Pa, young's module E
    H=5.84*10^9; %Pa Vickers hardness H 
    sigma_y=2.8*10^9; %Pa, yield strength of 
    mu=0.25; %( )possion ratio
    fraction=0.053;
end
end