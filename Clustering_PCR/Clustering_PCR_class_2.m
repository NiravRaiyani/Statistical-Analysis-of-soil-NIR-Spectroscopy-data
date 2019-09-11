clc;
clear all;
close all;
load ClassX2.mat;
load ClassY2.mat;
 %loading data
 %Responce variables
 Y_actual = classY2;
 %Regression variables
 X_actual = classX2;
 V1 = cond(X_actual);
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%Normalizing the test and training data%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %training data
 [T q] = size(X_actual);
 n= 28;
 X_Nt = normalize(X_actual(1:n,:));
 Y_Nt = normalize(Y_actual(1:n,:));
  
 X_mean = mean(X_actual(1:n,:))
 X_std = std(X_actual(1:n,:))
 
 Y_mean = mean(Y_actual(1:n,:))
 Y_std = std(Y_actual(1:n,:))
 %test data
 l=0;
 for i = 1 :q

 X_Nr(:,i) = (X_actual(n+1:end,i) - X_mean(1,i))/X_std(1,i);
 
 end
for j = 1:2
 Y_Nr(:,j) = (Y_actual(n+1:end,j) - Y_mean(1,j))/Y_std(1,j);
end

V2 = cond(X_actual);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PCA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%EXTRA CALCUALTION FOR VALIDATION OF THE DATA FROM PCA FUNCTION
%cov_X= cov(X_N);
%[eg ev] = eig(cov_X);
%temp = diag(ev);
%sortv = sort(temp);

%PCA of regressors
[coeff,score,latent,tsquared,explained,mu] = pca(X_Nt);

%scatter(score(:,1), score(:,2),score(:,3))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Scree Plot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sum = 0;
% for i = 1:43
%   sum = sum + explained(i,1);
%   scree(i) = sum;
% end
%plot(scree,'+','LineWidth',2)

%First 4 principle components explains almost 99% variance of regressors
%data set
%So new set of regressors is the first four column of score matrix 
X = score(:,1:4);
V3 = cond(X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PCR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Here,the first 72 observations are used to train the model

Xr1=[ones(n,1) X]
[beta,Sigma,E,CovB,logL] = mvregress(Xr1,Y_Nt);
Y_cap_training = Xr1*beta;

E_training = Y_Nt - Y_cap_training;

%Calcualring R2 for training data

D1=(Y_Nt(:,1)- mean(Y_Nt(:,1)))
R2_TRAINING1 =1- ((E(:,1)'*E(:,1))/(D1'*D1))

D2=(Y_Nt(:,2)- mean(Y_Nt(:,2)))
R2_TRAINING2 = 1-((E(:,2)'*E(:,2))/(D2'*D2))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Testing the model with the remaining 36 observations%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%determining the prinnciple score of test regressors from coefficients of
%training data

X2 = X_Nr*coeff(:,1:4);
Xr2 = [ones(T-n,1) X2]

Y_cap_test = Xr2*beta;
E_test = Y_Nr - Y_cap_test;

%Calcualring R2 for test data

Dt1=(Y_Nr(:,1)- mean(Y_Nr(:,1)));
R2_TEST1 =1-((E_test(:,1)'*E_test(:,1))/(Dt1'*Dt1))

Dt2=(Y_Nr(:,2)- mean(Y_Nr(:,2)));
R2_TEST2 = 1-((E_test(:,2)'*E_test(:,2))/(Dt2'*Dt2))

%As we can see that R2 of the second observation variable for test data set is
%very poor so it is expected that there is a presence of 2 clusters whose trend
%can be astimeted by two diffrent sets of regression coefficients.



