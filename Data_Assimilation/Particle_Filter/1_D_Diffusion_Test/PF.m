%% This file runs particle filter on a supplied model and parameters

PF_param; %runs m-file to generate model and model parameters

%global a;
%global bound;


forecast=zeros(N,length(u0));
for i=1:N
forecast(i,:)=u0;
%forecast(i,:)=x0*particle(2,i);
end


%% Loop over time
for tau=2:T/Dt+1

    obs = heat_data(tau,:); %get observations for current time

    %particle filter
    parfor n=1:N
%         parameters=particle(n,:);
        a=particle(1,n);
        
%        xend=heat_eul(Dt,forecast(n,:));
        [~,temp] = ode45(@(t,x) heat_equ(t,x,a),[0 Dt/2 Dt],forecast(n,:));
        xend = temp(end,:);
        forecast(n,:)=xend;
        W(n) = W(n)*exp(-1/2*(obs-xend)/R*(obs-xend)'); %note Gaussian assumption
    end
    W=W/sum(W);
    %test for filter collapse
    if isnan(W(1)) 
        error('Particle filter collapsed at time t = %f',tau*Dt)
    %test for resampling
    else if 1/sum(W.^2)/N < resamp_thresh 
            sampIndex = ResampSimp(W,N);
            particle = particle(:,sampIndex)+wiggle*randn(dim_param,N);
            forecast = forecast(sampIndex,:);
            W=1/N*ones(N,1);
        end
    end
    
end

%% Graphs and Plotting

figure
histogram(particle(1,:),50,'Normalization','Probability')

%figure
%plot(particle(1,:),particle(2,:),'o')
