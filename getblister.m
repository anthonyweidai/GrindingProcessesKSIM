function sigma_d=getblister(x,y,z,Fn)
%-all parameters-----------------------------------------------------------
% fraction=0.103; %(ww,2016) Volumn contraction of BK7
% E=83; %GPa, young's module E
% H=7.6; %GPa, Vickers hardness H 
% h=1*10^-6; %m, indentation depth
% %pi=3.1415926;%pi
 mu=0.203; %(Gu,2011)possion ratio
% psi=40/180*pi; %psi, 40 degree, half angle of the indenter
% % lamda=pi/( 4*tan(psi) ); %Ft:Fn=lamda 
% %The relationship between h and a(B)/Ft/Fn
% % B=fraction*E*a^3/(2*pi*tan(psi)*(1+mu)*(1-2*mu)); %Parameter B
% sigma_y=3.5; %GPa, yield strength of BK7
% a=h*tan(psi); %plastic zone diameter@@@@@@@@@@@@@@@@@@@@@@@@
% b=a*(  3*(1-2*mu)/(5-4*mu)+2*3^0.5/(pi*(5-4*mu))*E/sigma_y*cot(psi)  )^0.5;
% Fn=H*pi*a^2;%(mN)
% Ft=lamda*Fn;

%-cy\sp to cart------------------------------------------------------------
r=(x^2+y^2)^0.5;
rho=(x^2+y^2+z^2)^0.5;
z=-z;
%cartisan(Jing,2007)
sigma_xx=2*Fn*( -2*mu*(y^2-z^2)/(y^2+z^2)^2 + x/((y^2+z^2)^2*rho^5)*( 2*mu*x^4*y^2 -2*x^2*y^4 +6*mu*x^2*y^4 -2*y^6 +4*mu*y^6 -2*mu*x^4*z^2 -4*x^2*y^2*z^2 +2*mu*x^2*y^2*z^2 -3*y^4*z^2 +6*mu*y^4*z^2 -2*mu*x^2*z^4 -4*mu*x^2*z^4 +z^6 -2*mu*z^6 ));
sigma_yy=2*Fn*( -2*y^2*(y^2-3*z^2)/(y^2+z^2)^3 + x/((y^2+z^2)^3*rho^5)*( 2*x^4*y^4 +6*x^2*y^6 -2*mu*x^2*y^6 +4*y^8 -2*mu*y^8 -6*x^4*y^2*z^2 -7*x^2*y^4*z^2 -6*mu*x^2*y^4*z^2 -2*y^6*z^2 -8*mu*y^6*z^2 -12*x^2*y^2*z^4 -6*mu*x^2*y^2*z^4 -15*y^4*z^4 -12*mu*y^4*z^4 +x^2*z^6 -2*mu*x^2*z^6 -8*y^2*z^6 -8*mu*y^2*z^6 +z^8 -2*mu*z^8 ));
sigma_zz=2*Fn*(  2*z^2*(z^2-3*y^2)/(y^2+z^2)^3 +x*z^2/((y^2+z^2)^3*rho^5)*( 6*x^4*y^2 +15*x^2*y^4 +9*y^6 -2*x^4*z^2 +10*x^2*y^2*z^2 +12*y^4*z^2 -5*x^2*z^4 -3*y^2*z^4 -6*z^6 )  );
tau_xy=2*Fn*( -y*( 2*(1-mu)*x^2+2*(1-mu)*y^2 -z^2 -2*mu*z^2 ) /rho^5  );
tau_yx=tau_xy;
tau_yz=2*Fn*(  -4*y*z*(y^2-z^2)/(y^2+z^2)^3 +x*y*z/((y^2+z^2)^3*rho^5)*( 4*x^4*y^2 +10*x^2*y^4 +6*y^6 -4*x^4*z^2 +3*y^4*z^2 -10*x^2*z^4 -12*y^2*z^4 -9*z^6 )  );
tau_zy=tau_yz;
tau_zx=2*Fn*( -z*( 2*x^2+2*y^2-z^2 ) /rho^5  );
tau_xz=tau_zx;
sigma_d=[sigma_xx tau_yx tau_zx;tau_xy sigma_yy tau_zy;tau_xz tau_yz sigma_zz];

end