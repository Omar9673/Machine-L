clc
close all
clear all   

ds = datastore('house_prices_data_training_data.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);


T = read(ds);

x = T{1:17999,4:21}; %Input Data
m=length(x(:,1));
c=length(x(1,:));
for w=1:c    %Normalise or Scale X
    if max(abs(x(:,w)))~=0
    x(:,w)=(x(:,w)-mean((x(:,w))))./std(x(:,w));
    end
end
% miu=[];
% for i=1:c
% miu = [miu mean(x(:,i))];
% end
% miu=mean(x);
% co=cov(x);
% 
% sigma2 = var(x)' * (m - 1) / m;
% sigma2 = diag(sigma2);
% 
% 
% multiGaussian = (1/((2*pi)^(c/2))*(co.^(1/2)))*exp(-0.5*(x(1,:)-miu)*co'*(x(1,:)-miu)');
% multigaussian=mvncdf(x,miu,sigma2);

anomaly=0;
epsilon=0.000001;
for i=1:m
    for j=1:c
        if(qfunc(x(i,j))<epsilon || qfunc(x(i,j))>1-epsilon)
            anomaly=anomaly+1;
        end
    end
end


