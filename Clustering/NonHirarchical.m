 clc;
 clear all;
 close all;
 %loading data
 
 %Responce variables
 Y_actual = xlsread('Y.xlsx');
 %Regression variables
 X_actual = xlsread('X.xlsx')';
 V1 = cond(X_actual);
 
%Clustering

idx = kmeans(X_actual,2);

[coeff,score,latent,tsquared,explained,mu] = pca(X_actual);

[a b]=size(score);
[r c] = size(X_actual);
j=1;
k=1;

for i = 1:r

    if idx(i) == 1
       classS1(j,:) = score(i,:);
       classX1(j,:) = X_actual(i,:);
       classY1(j,:) = Y_actual(i,:);
        j=j+1;
    else 
        classS2(k,:) = score(i,:);
        classX2(k,:) = X_actual(i,:);
        classY2(k,:) = Y_actual(i,:);
        k=k+1;
    end
end
PCS = [classS1 ; classS2];
disp(size(classX1))
disp(size(classX2))
subplot(2,3,1)
    plot(PCS(1:61,1),PCS(1:61,2),'or',PCS(65:108,1),PCS(65:108,2),'*')
    xlabel('Scores along PC1')
    ylabel('Scores along PC2')
    
    legend('Class 1','Class 2')
subplot(2,3,2)
    plot(PCS(1:61,1),PCS(1:61,3),'or',PCS(65:108,1),PCS(65:108,3),'*')
    xlabel('Scores along PC1')
    ylabel('Scores along PC3')
    
    legend('Class 1','Class 3')
subplot(2,3,3)
    plot(PCS(1:61,1),PCS(1:61,4),'or',PCS(65:108,4),PCS(65:108,4),'*')
    xlabel('Scores along PC1')
    ylabel('Scores along PC4')
    
    legend('Class 1','Class 4')
subplot(2,3,4)
    plot(PCS(1:61,3),PCS(1:61,4),'or',PCS(65:108,3),PCS(65:108,4),'*')
    xlabel('Scores along PC3')
    ylabel('Scores along PC4')
   
    legend('Class 3','Class 4')
subplot(2,3,5)
    plot(PCS(1:61,2),PCS(1:61,3),'or',PCS(65:108,2),PCS(65:108,3),'*')
    xlabel('Scores along PC2')
    ylabel('Scores along PC3')
    
    legend('Class 2','Class 3')
subplot(2,3,6)
    plot(PCS(1:61,2),PCS(1:61,4),'or',PCS(65:108,2),PCS(65:108,4),'*')
    xlabel('Scores along PC2')
    ylabel('Scores along PC4')
   
    legend('Class 2','Class 4')
    