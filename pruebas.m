%% Set-up
clear;
close all;

load("X_tr.mat");
load("X_val.mat");
load("Y_tr.mat");
load("Y_val.mat");

Y_tr = int8(Y_tr);
Y_val = int8(Y_val);

%% Covariance Analysis
C = cov(X_tr);
image(C)
colorbar

det(C)

%% Correlation
imagesc(corr(X_tr))
colorbar


%% Knn with weight costs
k_values = [1,2,3,4,5,6,10,20,30,40, 100, 200, 300];
score = zeros(size(k_values));
for i=1:length(k_values)
    disp(i)
    Mdl = fitcknn(X_tr,Y_tr,'NumNeighbors',k_values(i),'Standardize',1, 'Cost', [0,1;mean(Y_tr==0)/mean(Y_tr==1),0])
    Predicted = predict(Mdl, X_val);
    score(i) = fbeta(Predicted, Y_val, 0.5)
end

%%
