
%Hypothesis No1 ---> Using bedrooms bathrooms condition & grade, mean
%                    normalisation, alpha=0.1,
%                    with regularisation. 
close all
clear all   
ds = datastore('house_prices_data_training_data.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
dstest = datastore('house_data_complete.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
Ttest=read(dstest);
size(T);
Alpha=.1;
m=length(T{1:17999,1});
mtest=length(Ttest{18000:end,1});

U=T{1:17999,4:5};
Utest=Ttest{18000:end,4:5};

U1=T{1:17999,11:12};
U1test=Ttest{18000:end,11:12};

X=[ones(m,1) U.^3 U1.^4];
Xtest=[ones(mtest,1) Utest.^3 U1test.^4];
lambda=0.01;

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
Theta=zeros(n,1);

k=1;
E(k)=(1/(2*m))*sum((X*Theta-Y).^2)+((lambda/(2*m))*sum(Theta.^2)); %Calculation Error (Cost function)
R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta*(1-((Alpha*lambda)/(m)))-(Alpha/(m))*X'*((X*Theta-Y)*X(k));
k=k+1
E(k)=(1/(2*m))*sum((X*Theta-Y).^2)+((lambda/(2*m))*sum(Theta.^2));
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


