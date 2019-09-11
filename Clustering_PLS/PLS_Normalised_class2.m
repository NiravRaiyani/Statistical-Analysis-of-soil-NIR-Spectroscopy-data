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

 %prepration of training data set
  X_train = [X_actual(1:7,:) ; X_actual(15:21,:) ; X_actual(28:34,:); X_actual(8:14,:) ; X_actual(22:27,:)]; 
  Y_train = [Y_actual(1:7,:) ; Y_actual(15:21,:) ; Y_actual(28:34,:); Y_actual(8:14,:) ; Y_actual(22:27,:)];
  
%   %prepration of test set
%   X_test = [X_actual(21:27,:) ; X_actual(48:54,:)]; 
%   Y_test = [Y_actual(21:27,:) ; Y_actual(48:54,:)];
% % 
  X_actual = X_train;
  Y_actual = Y_train;
 
 
 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%Normalizing the test and training data%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %training data
 [T q] = size(X_actual);
 n= 24;
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







%%%%%%%%%%%%%%%%%%%%%%%%%%% PLS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(X_Nt,Y_Nt,4);

Y_cap_training = [ones(n,1)  X_Nt]*BETA;


E_training = Y_Nt - Y_cap_training;

%Calcualring R2 for training data

D1=(Y_Nt(:,1)- mean(Y_Nt(:,1)))
R2_TRAINING1 =1- ((E_training(:,1)'*E_training(:,1))/(D1'*D1))

D2=(Y_Nt(:,2)- mean(Y_Nt(:,2)))
R2_TRAINING2 = 1-((E_training(:,2)'*E_training(:,2))/(D2'*D2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Testing the model with the remaining 36 observations%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xt = [ones((T-n),1) X_Nr];
Y_cap_test = Xt*BETA;

E_test = Y_Nr - Y_cap_test;

%Calcualring R2 for test data

Dt1=(Y_Nr(:,1)- mean(Y_Nr(:,1)));
R2_TEST1 =1-((E_test(:,1)'*E_test(:,1))/(Dt1'*Dt1))

Dt2=(Y_Nr(:,2)- mean(Y_Nr(:,2)));
R2_TEST2 = 1-((E_test(:,2)'*E_test(:,2))/(Dt2'*Dt2))


