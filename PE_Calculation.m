function [Linear_Pe_train,Linear_Pe_test,Quadratic_Pe_train,Quadratic_Pe_test]=PE_Calculation(X_train,Labels_train,X_test,Labels_test)
%Compute Linear Pe's
linclass = fitcdiscr(X_train,Labels_train,'prior','empirical', 'discrimType', 'pseudoLinear');
Linear_out = predict(linclass,X_train);
Linear_Pe_train=sum(Labels_train ~= Linear_out)/length(Labels_train);

Linear_out = predict(linclass,X_test);
Linear_Pe_test=sum(Labels_test ~= Linear_out)/length(Labels_test);

%Compute Quadratic Pe's
quaclass = fitcdiscr(X_train,Labels_train,'discrimType','pseudoQuadratic','prior','empirical');
Quadratic_out= predict(quaclass,X_train);
Quadratic_Pe_train=sum(Labels_train ~= Quadratic_out)/length(Labels_train);

Quadratic_out= predict(quaclass,X_test);
Quadratic_Pe_test=sum(Labels_test ~= Quadratic_out)/length(Labels_test);
end