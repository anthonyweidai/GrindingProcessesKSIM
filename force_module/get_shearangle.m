function [theta_a,beta_a]=get_shearangle(alpha)
theta_a=16-(60-alpha)/60*10; %shear angle
beta_a=(45-theta_a-alpha/2)*2;
end