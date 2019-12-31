function score=fbeta(Labels_Predicted, Labels_GT, beta)
    precision = sum(Labels_Predicted == Labels_GT & Labels_GT == 1)/sum(Labels_Predicted==1);
    recall = sum(Labels_Predicted == Labels_GT & Labels_GT == 1 )/sum(Labels_GT==1);
    
    score = (1+beta^2)*(precision*recall)/(recall + precision*(beta^2));
end