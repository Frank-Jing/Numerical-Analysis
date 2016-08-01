function  u_dot  = heat_equ(t,u,a )

%global a

N=length(u);
u_dot = zeros(N,1);

for i=2:N-1
    u_dot(i)=a/(1/(N-1))^2*(u(i+1)+u(i-1)-2*u(i));
end