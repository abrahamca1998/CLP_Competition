clear all
load X_Test.mat
load Train_Validation.mat
%% Tree
tree = fitctree([X_tr;X_val],[Y_tr;Y_val],'Cost', [0,1;mean(Y_tr==0)/mean(Y_tr==1)-0.02,0]);
outputs_train=predict(tree,[X_tr;X_val]);
disp(fbeta(outputs_train,[Y_tr;Y_val],1));
outputs = predict(tree,X_Test);
outputs(mask)=0;
%% KNN
KNN = fitcknn(X_tr,Y_tr,'NumNeighbors',5,'Standardize',1, 'Cost', [0,1;mean(Y_tr==0)/mean(Y_tr==1),0]);
outputs_train=predict(KNN,[X_tr;X_val]);
disp(fbeta(outputs_train,[Y_tr;Y_val],1));
outputs = predict(KNN,X_test);
outputs(mask)=0;
%% SVM
linclass = fitcsvm([X_tr;X_val], [Y_tr;Y_val], 'Cost', [0,1;mean(Y_tr==0)/mean(Y_tr==1),0], 'Standardize', true, 'KernelFunction','RBF'); 
outputs_train=predict(linclass,[X_tr;X_val]);
disp(fbeta(outputs_train,[Y_tr;Y_val],1));
outputs(mask)=0;
%% NN
load Train_Validation.mat
load Test.mat
X=[X_tr;X_val];
Y=[Y_tr;Y_val];
x = X';
t = Y';
weights=[1,mean(Y_tr==0)/mean(Y_tr==1)-0.02];
class1=find(Y==0);
class2=find(Y==1);
ew=zeros(1,length(Y));
ew(class1)=weights(2);
ew(class2)=weights(1);


% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 50;
net = patternnet(hiddenLayerSize, trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'crossentropy';  % Cross-Entropy

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};

% Train the Network
[net,tr] = train(net,x,t,[],[],ew);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)
disp(fbeta(y>=0.5,t,1))

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotconfusion(t,y)
%figure, plotroc(t,y)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% See the help for each generation function for more information.
if (false)
    % Generate MATLAB function for neural network for application
    % deployment in MATLAB scripts or with MATLAB Compiler and Builder
    % tools, or simply to examine the calculations your trained neural
    % network performs.
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end
outputs= net(X_Test);
outputs=outputs>=0.5;
outputs(mask)=0;


%%
Ntest = 9158; 
id = [1:Ntest]; 
T = table(id', outputs', 'VariableNames', {'Id', 'Label'}); 
writetable(T, 'outputs.csv', 'WriteVariableNames',true)




