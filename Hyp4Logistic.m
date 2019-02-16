
%Logistic Hypothesis No1 ---> ALpha=0.1, 3 features trestbps, chol & thalach linear and quadratic, mean
%normalisation, thetas=0s.

clear all   
ds = datastore('heart_DD.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);
T = read(ds);
Alpha=.1;
m=length(T{1:175,1});
mtest=length(T{176:end,1});
U=T{1:175,4};
Utest=T{176:end,4};
U1=T{1:175,5};
U1test=T{176:end,5};
U2=T{1:175,8};
U2test=T{176:end,8};
X=[ones(m,1) U U1 U2 U.^2 U1.^2 U2.^2 U.^3 U1.^3 U2.^3];
Xtest=[ones(mtest,1) Utest U1test U2test Utest.^2 U1test.^2 U2test.^2 Utest.^3 U1test.^3 U2test.^3];


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

Y=T{1:175,14}/mean(T{1:175,14});%Normalise Y
Ytest=T{176:end,14}/mean(T{1:175,14});
Theta=zeros(n,1);
k=1;
E(k)=-(1/(m))*sum((Y'.*log(1./(1+exp((-Theta')*X'))))+((1-Y').*log(1./(1+exp((-Theta')*X'))))); %Calculation Error (Cost function)
R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta-(Alpha/m)*X'*(((log(1./(1+exp((-Theta')*X'))))-Y')');
k=k+1
E(k)=-(1/(m))*sum((Y'.*log(1./(1+exp((-Theta')*X'))))+((1-Y').*log(1./(1+exp((-Theta')*X')))));
if E(k-1)-E(k)<0
    break
end 
q=(E(k-1)-E(k))./E(k-1);
if q <.0001;
    R=0;
end
end
figure(1)
plot(E)

%Testing Data:
Etest=-(1/(mtest))*sum((Ytest'.*log(1./(1+exp((-Theta')*Xtest'))))+((1-Ytest').*log(1./(1+exp((-Theta')*Xtest')))));
