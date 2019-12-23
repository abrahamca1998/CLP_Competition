%% Cell array to .mat file
clear all

T_Train = readtable('ML-MATT-CompetitionQT1920_Train.csv');
letter2number = @(c)1+lower(c)-'a';

Time_Train=T_Train.Time;
Cell_Name_Train=T_Train.CellName;

Time=zeros(size(Time_Train));
Cell_Letter=zeros(size(Cell_Name_Train));
Cell_Number=zeros(size(Cell_Name_Train));


for i=1:length(Time_Train)
    
    time_sample=char(Time_Train(i));
    Cell_Type_Sample=char(Cell_Name_Train(i));
    
    LTE_expression='LTE';
    LTE_index=regexp(Cell_Type_Sample,LTE_expression);
    Cell_Letter(i)=letter2number(Cell_Type_Sample(LTE_index-1));
    Cell_Number(i)=str2double(Cell_Type_Sample(1:LTE_index-2));
    
    
    expression = ':[0-9][0-9]';
    doble_point_index = regexp(time_sample,expression);
    hours=str2double(time_sample(1:doble_point_index-1));
    minutes=str2double(time_sample(doble_point_index+1:end));
    
    minutes_fraction=0;
    switch minutes
        case 0
            minutes_fraction=0;
        case 15
            minutes_fraction=1/4;
        case 30
            minutes_fraction=1/2;
        case 45
            minutes_fraction=3/4;
    end
    
    Time(i)=(hours+minutes_fraction)*(pi/12);

end


Unique_Letters=unique(Cell_Letter);
Cell_Letter(find(Cell_Letter==Unique_Letters(4)))=4;
Cell_Letter(find(Cell_Letter==Unique_Letters(5)))=5;
Cell_Letter(find(Cell_Letter==Unique_Letters(6)))=6;

OneHot_Cell_Number = full(ind2vec(Cell_Number'))';
OneHot_Cell_Letter = full(ind2vec(Cell_Letter'))';

num_features=27;
Size_Train=size(T_Train);
X_Train=zeros(Size_Train(1),num_features);
X_Train(:,1)=Time;
X_Train(:,2:11)=OneHot_Cell_Number;
X_Train(:,12:17)=OneHot_Cell_Letter;
X_Train(:,18)=T_Train.PRBUsageUL;
X_Train(:,19)=T_Train.PRBUsageDL;
X_Train(:,20)=T_Train.meanThr_DL;
X_Train(:,21)=T_Train.meanThr_UL;
X_Train(:,22)=T_Train.maxThr_DL;
X_Train(:,23)=T_Train.maxThr_UL;
X_Train(:,24)=T_Train.meanUE_DL;
X_Train(:,25)=T_Train.meanUE_UL;
X_Train(:,26)=T_Train.maxUE_DL;
X_Train(:,27)=T_Train.maxUE_UL;
Y_Train=T_Train.Unusual;
%X_Train(28)=T_Train.maxUE_UL_DL;
save('X_Train.mat','X_Train')
save('Y_Train.mat','Y_Train')

%% Clean Data Train
clear all
load('X_Train.mat');
load('Y_Train.mat');
% Delete wrong rows
% Delete nans
nans=isnan(X_Train);
nans_per_row=sum(nans==1,2);
mask=nans_per_row~=0;
% traffic but no active users
mask= mask | (X_Train(:,20)==0) & (X_Train(:,24)>0); %DL
mask = mask | (X_Train(:,21)==0) & (X_Train(:,25)>0); %UL;

% resource usage but no traffic
mask = mask | (X_Train(:,19)>0) & (X_Train(:,20) == 0); % DL
mask = mask | (X_Train(:,18)>0) & (X_Train(:,21) == 0); % UL

% Mean higher than maximum
mask = mask | (X_Train(:,22) < X_Train(:,20)); % traffic DL
mask = mask | (X_Train(:,23) < X_Train(:,21)); % traffic UL 

mask = mask | (X_Train(:,22) < X_Train(:,22)); % users DL
mask = mask | (X_Train(:,22) < X_Train(:,22)); % users UL

mask=~mask;
X_Train=X_Train(mask,:);
Y_Train=Y_Train(mask);

save('X_Train.mat','X_Train')
save('Y_Train.mat','Y_Train')


%% Cell Test to mat file
clear all

T_Test = readtable('ML-MATT-CompetitionQT1920_test.csv');
letter2number = @(c)1+lower(c)-'a';

Time_Test=T_Test.Time;
Cell_Name_Test=T_Test.CellName;

Time=zeros(size(Time_Test));
Cell_Letter=zeros(size(Cell_Name_Test));
Cell_Number=zeros(size(Cell_Name_Test));


for i=1:length(Time_Test)
    
    time_sample=char(Time_Test(i));
    Cell_Type_Sample=char(Cell_Name_Test(i));
    
    LTE_expression='LTE';
    LTE_index=regexp(Cell_Type_Sample,LTE_expression);
    Cell_Letter(i)=letter2number(Cell_Type_Sample(LTE_index-1));
    Cell_Number(i)=str2double(Cell_Type_Sample(1:LTE_index-2));
    
    
    expression = ':[0-9][0-9]';
    doble_point_index = regexp(time_sample,expression);
    hours=str2double(time_sample(1:doble_point_index-1));
    minutes=str2double(time_sample(doble_point_index+1:end));
    
    minutes_fraction=0;
    switch minutes
        case 0
            minutes_fraction=0;
        case 15
            minutes_fraction=1/4;
        case 30
            minutes_fraction=1/2;
        case 45
            minutes_fraction=3/4;
    end
    
    Time(i)=(hours+minutes_fraction)*(pi/12);

end


Unique_Letters=unique(Cell_Letter);
Cell_Letter(find(Cell_Letter==Unique_Letters(4)))=4;
Cell_Letter(find(Cell_Letter==Unique_Letters(5)))=5;
Cell_Letter(find(Cell_Letter==Unique_Letters(6)))=6;

OneHot_Cell_Number = full(ind2vec(Cell_Number'))';
OneHot_Cell_Letter = full(ind2vec(Cell_Letter'))';

num_features=27;
Size_Test=size(T_Test);
X_Test=zeros(Size_Test(1),num_features);
X_Test(:,1)=Time;
X_Test(:,2:11)=OneHot_Cell_Number;
X_Test(:,12:17)=OneHot_Cell_Letter;
X_Test(:,18)=T_Test.PRBUsageUL;
X_Test(:,19)=T_Test.PRBUsageDL;
X_Test(:,20)=T_Test.meanThr_DL;
X_Test(:,21)=T_Test.meanThr_UL;
X_Test(:,22)=T_Test.maxThr_DL;
X_Test(:,23)=T_Test.maxThr_UL;
X_Test(:,24)=T_Test.meanUE_DL;
X_Test(:,25)=T_Test.meanUE_UL;
X_Test(:,26)=T_Test.maxUE_DL;
X_Test(:,27)=T_Test.maxUE_UL;
%X_Test(28)=T_Test.maxUE_UL_DL;
save('X_Test.mat','X_Test')

%% Clean Data Test
clear all
load('X_Test.mat');
% Delete wrong rows
% Delete nans
nans=isnan(X_Test);
nans_per_row=sum(nans==1,2);
mask=nans_per_row~=0;
% traffic but no active users
mask= mask | (X_Test(:,20)==0) & (X_Test(:,24)>0); %DL
mask = mask | (X_Test(:,21)==0) & (X_Test(:,25)>0); %UL;

% resource usage but no traffic
mask = mask | (X_Test(:,19)>0) & (X_Test(:,20) == 0); % DL
mask = mask | (X_Test(:,18)>0) & (X_Test(:,21) == 0); % UL

% Mean higher than maximum
mask = mask | (X_Test(:,22) < X_Test(:,20)); % traffic DL
mask = mask | (X_Test(:,23) < X_Test(:,21)); % traffic UL 

mask = mask | (X_Test(:,22) < X_Test(:,22)); % users DL
mask = mask | (X_Test(:,22) < X_Test(:,22)); % users UL

mask=~mask;
X_Test=X_Test(mask,:);

save('X_Test.mat','X_Test')

%% Split in Validation/Train
clear all
load('X_train.mat')
load('Y_train.mat')
[trainInd,valInd,testInd] = dividerand(length(X_Train),0.7,0.3,0.0);
X_tr=X_Train(trainInd,:);
Y_tr=Y_Train(trainInd);
X_val=X_Train(valInd,:);
Y_val=Y_Train(valInd);

save('X_tr.mat','X_tr');
save('Y_tr.mat','Y_tr');
save('X_val.mat','X_val');
save('Y_val.mat','Y_val');





