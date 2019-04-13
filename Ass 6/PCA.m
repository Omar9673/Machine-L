clc
close all
clear all   

ds = datastore('house_prices_data_training_data.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);


T = read(ds);

x = T{1:17999,4:21}; %Input Data

c=length(x(1,:));
for w=1:c    %Normalise or Scale X
    if max(abs(x(:,w)))~=0
    x(:,w)=(x(:,w)-mean((x(:,w))))./std(x(:,w));
    end
end

Corr_x=corr(x); %Correlation Matrix

x_cov=cov(x); %Covariance Matrix 

[U,S,V] =  svd(x_cov); %Singular value decomposition 

EigenValues=diag(S); %Placing eigen values in a vector
m1=length(EigenValues);


for K=1:m1 %Finding K
    Ktemp=K;
    alpha=1-((sum(EigenValues(1:K)))/(sum(EigenValues)));
    if alpha<=0.001
        break
    end
    
end

R=U(:,1:K)'*x'; %Reduced Data 

AppData=(U(:,1:K)*R)'; %Approximate Data 

Error=(1/(length(AppData)))*sum((x-AppData).^2);
AvgError=mean(Error);  %Calculating Error

%-------------------------------------------------------------------------%
%Linear Regression:
Alpha=0.1;
X=[ones(length(AppData),1) AppData];
m=length(T{1:17999,1});
n=length(X(1,:));
Y=T{1:17999,3}/mean(T{1:17999,3}); %Normalise Y
Theta=zeros(n,1);
i=1;
E(i)=(1/(2*m))*sum((X*Theta-Y).^2); %Calculation Error (Cost function)

R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta-(Alpha/m)*X'*(X*Theta-Y);
i=i+1;
E(i)=(1/(2*m))*sum((X*Theta-Y).^2);
if E(i-1)-E(i)<0
    break
end 
q=(E(i-1)-E(i))./E(i-1)
if q <.00001;
    R=0;
end
end
figure(1)
plot(E)
xlabel('Iterations')
ylabel('Error')



