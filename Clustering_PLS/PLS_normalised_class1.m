 clc;
clear all;
close all;
load ClassX1.mat;
load Classy1.mat;
 %loading data
 
 %Responce variables
 Y_actual = classY1;
 %Regression variables
 X_actual = classX1;
 V1 = cond(X_actual);
 [coeff,score,latent,tsquared,explained,mu] = pca(X_actual);
outlier = isoutlier(score(:,1:4))

 %prepration of training data set
 X_train = [X_actual(1:20,:) ; X_actual(28:47,:) ; X_actual(61:74,:); X_actual(21:27,:) ; X_actual(48:59,:)]; 
 Y_train = [Y_actual(1:20,:) ; Y_actual(28:47,:) ; Y_actual(61:74,:); Y_actual(21:27,:) ; Y_actual(48:59,:)];
 
 %prepration of test set
 %X_test = [X_actual(21:27,:) ; X_actual(48:54,:)]; 
 %Y_test = [Y_actual(21:27,:) ; Y_actual(48:54,:)];

 X_actual = X_train;
 Y_actual = Y_train;
 
 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%Normalizing the test and training data%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %training data
 [T q] = size(X_actual);
 n= 40;
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



[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] = plsregress(X_Nt,Y_Nt,10);

Y_cap_training = [ones(n,1)  X_Nt]*BETA;


E_training = Y_Nt - Y_cap_training;

%Calcualring R2 for training data

D1=(Y_Nt(:,1)- mean(Y_Nt(:,1)));
R2_TRAINING1 =1- ((E_training(:,1)'*E_training(:,1))/(D1'*D1))

D2=(Y_Nt(:,2)- mean(Y_Nt(:,2)));
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


