clc;
 clear all
 close all;
 %loading data
 
 %Responce variables
 Y_actual = xlsread('Y.xlsx');
 %Regression variables
 X_actual = xlsread('X.xlsx')';
 V1 = cond(X_actual);
 %Normalizing the data

X_N= normalize(X_actual);
Y_N= normalize(Y_actual);
V2 = cond(X_actual);

%PCA of regressors
[coeff,score,latent,tsquared,explained,mu] = pca(X_N);


%%%%%%%Single Linkage%%%%%%%%%%
Z1 = linkage(X_actual,'single');
figure(1)
dendrogram(Z1,0)

%%%%%%%Complete Linkage%%%%%%%%%%
Z2 = linkage(X_actual,'complete');
figure(2)
dendrogram(Z2,0)

%%%%%%%Average Linkage%%%%%%%%%%
Z3 = linkage(X_actual,'average');
figure(3)
dendrogram(Z3,0)






