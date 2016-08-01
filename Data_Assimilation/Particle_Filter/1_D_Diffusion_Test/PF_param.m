N = 1000; %number of particles in filter

o_sigma=1e-1; %observational error variance
R=o_sigma*eye(100); 


T=.2; %final time
Dt=1e-2;

resamp_thresh=0.4; %threshold for resampling
wiggle=1e-3; %noise in parameter values after resampling

%% Generate particles
%global a; global bound;
a= 0.5; %true values
%bound = 1;
min_guess=[0]; max_guess=[1];
dim_param = length(min_guess);
particle = samp_param(min_guess,max_guess,N);
W = ones(N,1)/N;  %uniform weight


%% Generate obs 

x0=(0:99)/99;
%u0=sqrt(x0);
u0=cos(2*pi*x0);
%u0 = x0*bound;
%m=T/Dt;


[~,heat_data] = ode45(@(t,x) heat_equ(t,x,a),0:Dt:T,u0);
