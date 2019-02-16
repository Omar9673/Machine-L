%                After scattering the features against the price and trying
%                to find the relations, I came up with this hypothesis.
%                Alpha= 0.01.
clc
close all
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
U=T{1:17999,4};
Utest=Ttest{18000:end,4};
U1=T{1:17999,5};
U1test=Ttest{18000:end,5};
U2=T{1:17999,6};
U2test=Ttest{18000:end,6};
U3=T{1:17999,7};
U3test=Ttest{18000:end,7};
U4=T{1:17999,11};
U4test=Ttest{18000:end,11};
U5=T{1:17999,12};
U5test=Ttest{18000:end,12};
U6=T{1:17999,13};
U6test=Ttest{18000:end,13};
U7=T{1:17999,20};
U7test=Ttest{18000:end,20};
U8=T{1:17999,21};
U8test=Ttest{18000:end,21};
X=[ones(m,1) 8*sin(0.3.*U) U1 U2 U3.^(-1) U4 0.5.*U5 0.7.*U6 0.6.*U7 U8.^(-1)];
Xtest=[ones(mtest,1) 8*sin(0.3.*Utest) U1test U2test U3test.^(-1) U4test 0.5.*U5test 0.7.*U6test 0.6.*U7test U8test.^(-1)];

n=length(X(1,:));
for w=2:n    %Normalise or Scale X
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
end

ntest=length(Xtest(1,:));
for w=2:ntest    %Normalise or Scale X
    if max(abs(Xtest(:,w)))~=0
    Xtest(:,w)=(Xtest(:,w)-mean((Xtest(:,w))))./std(Xtest(:,w));
    end
end

Y=T{1:17999,3}/mean(T{1:17999,3}); %Normalise Y
Ytest=Ttest{18000:end,3}/mean(T{1:17999,3});
Theta=zeros(n,1);
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