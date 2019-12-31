clear all;

load X_tr.mat
load Y_tr.mat

N = 1000

X = X_tr(1:N,:);
Y = Y_tr(1:N);

Yh = tsne(X, 'Algorithm','exact');

gscatter(Yh(:,1),Yh(:,2),Y,eye(2)) 
title('2-D Embedding')


