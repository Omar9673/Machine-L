
%Hypothesis No1 ---> Using all features with 'sqft', mean
%                    normalisation, alpha=0.01, 1st & 2nd degree polynomials,
%                    thetas= 1s, no regularisation.
close all
clc
clear all   
ds = datastore('house_prices_data_training_data.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
dstest = datastore('house_data_complete.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
Ttest=read(dstest);
size(T);
Alpha=0.01;
m=length(T{1:17999,1});
mtest=length(Ttest{18000:end,1});
U=T{1:17999,6:7};
Utest=Ttest{18000:end,6:7};
U1=T{1:17999,13:14};
U1test=Ttest{18000:end,13:14};
U2=T{1:17999,20:21};
U2test=Ttest{18000:end,20:21};
% X=[ones(m,1) U U1 U.^2 U.^3];
X=[ones(m,1) U U1 U2 U.^2 U1.^2 U2.^2];
Xtest=[ones(mtest,1) Utest U1test U2test Utest.^2 U1test.^2 U2test.^2];

n=length(X(1,:));
for w=2:n    %Normalise or Scale X
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
end

ntest=length(Xtest(1,:));
for w=2:ntest    %Normalise or Scale Xtest
    if max(abs(Xtest(:,w)))~=0
    Xtest(:,w)=(Xtest(:,w)-mean((Xtest(:,w))))./std(Xtest(:,w));
    end
end

Y=T{1:17999,3}/mean(T{1:17999,3}); %Normalise Y 
Ytest=Ttest{18000:end,3}/mean(T{1:17999,3});
Theta=ones(n,1);
k=1;

E(k)=(1/(2*m))*sum((X*Theta-Y).^2); %Calculation Error (Cost function)

R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta-(Alpha/m)*X'*(X*Theta-Y);
k=k+1
E(k)=(1/(2*m))*sum((X*Theta-Y).^2);
if E(k-1)-E(k)<0
    break
end 
q=(E(k-1)-E(k))./E(k-1);
if q <.00001;
    R=0;
end
end
figure(1)
plot(E)

%Testing Data:
TestPrices=Xtest*Theta;
MSE=((TestPrices-Ytest).^2)/(2*(mtest));
MSEsum=sum(MSE);
figure(2)
plot(MSE)