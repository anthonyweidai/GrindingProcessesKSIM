function sigma_d=getcerruti(x,y,z,Fn)
%-all parameters-----------------------------------------------------------
% fraction=0.103; %(ww,2016) Volumn contraction of BK7
% E=83; %GPa young's module E
% H=7.6; %GPa Vickers hardness H 
% a=1; %plastic zone diameter@@@@@@@@@@@@@@@@@@@@@@@@
% %pi=3.1415926;%pi
 mu=0.203; %(Gu,2011)possion ratio
% psi=40/180*pi; %psi
% lamda=pi/( 4*tan(psi) ); %Ft:Fn=lamda 
% %The relationship between h and a(B)/Ft/Fn
% B=fraction*E*a^3/(2*pi*tan(psi)*(1+mu)*(1-2*mu)); %Parameter B
% Fn=H*pi*a;%(mN)
% Ft=lamda*Fn;
%-cy\sp to cart------------------------------------------------------------
r=(x^2+y^2)^0.5;
rho=(x^2+y^2+z^2)^0.5;
z=-z;

%cartisan(Jing,2007)
sigma_xx=Fn/(2*pi)*( (1-2*mu)*( x/rho^3-3*x/(rho*(rho+z)^2)+x^3/(rho^3*(rho+z)^2)+2*x^3/(rho^2*(rho+z)^3) )-3*x^3/rho^5 );
sigma_yy=Fn/(2*pi)*( (1-2*mu)*( x/rho^3-x/(rho*(rho+z)^2)+x*y^2/(rho^3*(rho+z)^2)+2*x*y^2/(rho^2*(rho+z)^3) )-3*x*y^2/rho^5 );
sigma_zz=-3*Fn/(2*pi)*(x*z^2/rho^5);
tau_xy=Fn/(2*pi)*( (1-2*mu)*( -y/(rho*(rho+z)^2)+x^2*y/(rho^3*(rho+z)^2)+2*x^2*y/(rho^2*(rho+z)^3) )-3*x^2*y/rho^5 );
tau_yx=tau_xy;
tau_yz=-3*Fn/(2*pi)*(x*y*z/rho^5);
tau_zy=tau_yz;
tau_zx=-3*Fn/(2*pi)*(x^2*z/rho^5);
tau_xz=tau_zx;
sigma_d=[sigma_xx tau_yx tau_zx;tau_xy sigma_yy tau_zy;tau_xz tau_yz sigma_zz];

end