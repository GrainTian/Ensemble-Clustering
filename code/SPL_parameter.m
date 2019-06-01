function [precision1,precision2] = SPL_parameter(Data,X,y,runs,sigRange,delRange,lamRange)
% ============Parameter Analysis============
% sigRange - Range of sigma
% delRange - Range of delta
% lamRange - Range of lambda
T1=clock;
close all;
lenSig = length(sigRange);
lenDel = length(delRange);
lenLam = length(lamRange);
sum_precision1 = zeros(runs,lenSig); % LR with Gaussian Noise
sum_precision2 = zeros(runs,lenSig); % SPL_LR with Gaussian Noise (Unbalanced)
sum_precision3 = zeros(runs,lenSig); % SPL_LR with Gaussian Noise (Balanced)
sum_precision4 = zeros(runs,lenDel); % LR with Dropout Noise
sum_precision5 = zeros(runs,lenDel); % SPL_LR with Dropout Noise (Unbalanced)
sum_precision6 = zeros(runs,lenDel); % SPL_LR with Dropout Noise (Balanced)
sum_precision7 = zeros(runs,lenLam); % LR with L2-norm
sum_precision8 = zeros(runs,lenLam); % SPL_LR with L2-norm (Unbalanced)
sum_precision9 = zeros(runs,lenLam); % SPL_LR with L2-norm (Balanced)
%rand('seed', 0);
for run=1:runs    
    cp = cvpartition(y,'k',10);        
    fprintf('\ndataset=%s; run=%d; time=%s\n',Data,run,datestr(now));
    for ii=1:lenSig
        sigma = sigRange(ii);
        fprintf('dataset=%s, using LR-GN\n',Data);  
        ClassFun = @(XTrain,yTrain,XTest)(myPredict(myLRClassifier(XTrain,...
                    double(yTrain),sigma,'GaussianNoise'), XTest));
        cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);
        sum_precision1(run,ii) = (1-cvMCR)*100;
%         theta = myLRClassifier(XTrain, yTrain,sigma,'GaussianNoise');
%         prediction = myPredict(theta, XTest);
%         sum_precision1(run,ii) = mean(double(prediction == yTest)) * 100;
        fprintf('dataset=%s, using SPL-GN\n',Data);  
        ClassFun = @(XTrain,yTrain,XTest)(myPredict(SPL_LR(XTrain,...
                    double(yTrain), sigma, 'GaussianNoise', 'Unbalanced'), XTest));
        cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);       
        sum_precision2(run,ii) = (1-cvMCR)*100;
%         theta = SPL_LR(XTrain, yTrain, sigma, 'GaussianNoise', 'Unbalanced');
%         prediction = myPredict(theta, XTest);
%         sum_precision2(run,ii) = mean(double(prediction == yTest)) * 100;
        fprintf('dataset=%s, using BSPL-GN\n',Data);  
        ClassFun = @(XTrain,yTrain,XTest)(myPredict(SPL_LR(XTrain,...
                    double(yTrain), sigma, 'GaussianNoise', 'Balanced'), XTest));
        cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);       
        sum_precision3(run,ii) = (1-cvMCR)*100;        
%         theta = SPL_LR(XTrain, yTrain, sigma, 'GaussianNoise', 'Balanced');
%         prediction = myPredict(theta, XTest);
%         sum_precision3(run,ii) = mean(double(prediction == yTest)) * 100;
    end
    
    for ii=1:lenDel
        delta = delRange(ii);
        fprintf('dataset=%s, using LR-DN\n',Data);  
        ClassFun = @(XTrain,yTrain,XTest)(myPredict(myLRClassifier(XTrain,...
            double(yTrain),delta,'DropoutNoise'), XTest));
        cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);       
        sum_precision4(run,ii) = (1-cvMCR)*100;                
%         theta = myLRClassifier(XTrain, yTrain,delta,'DropoutNoise');
%         prediction = myPredict(theta, XTest);
%         sum_precision4(run,ii) = mean(double(prediction == yTest)) * 100;
        fprintf('dataset=%s, using SPL-DN\n',Data);  
        ClassFun = @(XTrain,yTrain,XTest)(myPredict(SPL_LR(XTrain,...
            double(yTrain), delta, 'DropoutNoise', 'Unbalanced'), XTest));
        cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);       
        sum_precision5(run,ii) = (1-cvMCR)*100;             
%         theta = SPL_LR(XTrain, yTrain, delta, 'DropoutNoise', 'Unbalanced');
%         prediction = myPredict(theta, XTest);
%         sum_precision5(run,ii) = mean(double(prediction == yTest)) * 100;
        fprintf('dataset=%s, using BSPL-DN\n',Data);          
        ClassFun = @(XTrain,yTrain,XTest)(myPredict(SPL_LR(XTrain,...
            double(yTrain), delta, 'DropoutNoise', 'Balanced'), XTest));
        cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);
        sum_precision6(run,ii) = (1-cvMCR)*100;        
%         theta = SPL_LR(XTrain, yTrain, delta, 'DropoutNoise', 'Balanced');
%         prediction = myPredict(theta, XTest);
%         sum_precision6(run,ii) = mean(double(prediction == yTest)) * 100;
    end
    
    for ii=1:lenLam
        lambda = lamRange(ii);
        fprintf('dataset=%s, using LR-L2\n',Data);  
        ClassFun = @(XTrain,yTrain,XTest)(myPredict(myLRClassifier(XTrain,...
            double(yTrain),lambda,'NoNoise'), XTest));
        cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);       
        sum_precision7(run,ii) = (1-cvMCR)*100;            
%         theta = myLRClassifier(XTrain, yTrain,lambda,'NoNoise');
%         prediction = myPredict(theta, XTest);
%         sum_precision7(run,ii) = mean(double(prediction == yTest)) * 100;
%         fprintf('dataset=%s, using SPL-L2\n',Data);  
%         ClassFun = @(XTrain,yTrain,XTest)(myPredict(SPL_LR(XTrain,...
%             double(yTrain), lambda, 'NoNoise', 'Unbalanced'), XTest));
%         cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);       
%         sum_precision8(run,ii) = (1-cvMCR)*100;     
% %         theta = SPL_LR(XTrain, yTrain, lambda, 'NoNoise', 'Unbalanced');
% %         prediction = myPredict(theta, XTest);
% %         sum_precision8(run,ii) = mean(double(prediction == yTest)) * 100;
%         fprintf('dataset=%s, using BSPL-L2\n',Data);  
%         ClassFun = @(XTrain,yTrain,XTest)(myPredict(SPL_LR(XTrain,...
%             double(yTrain), lambda, 'NoNoise', 'Balanced'), XTest));
%         cvMCR= crossval('mcr',X,y,'predfun',ClassFun,'partition',cp);       
%         sum_precision9(run,ii) = (1-cvMCR)*100;            
% %         theta = SPL_LR(XTrain, yTrain, lambda, 'NoNoise', 'Balanced');
% %         prediction = myPredict(theta, XTest);
% %         sum_precision9(run,ii) = mean(double(prediction == yTest)) * 100;
    end
end
precision1=sum(sum_precision1,1)/runs;precision2=sum(sum_precision2,1)/runs;
precision3=sum(sum_precision3,1)/runs;precision4=sum(sum_precision4,1)/runs;
precision5=sum(sum_precision5,1)/runs;precision6=sum(sum_precision6,1)/runs;
precision7=sum(sum_precision7,1)/runs;precision8=sum(sum_precision8,1)/runs;
precision9=sum(sum_precision9,1)/runs;

filename=[pwd filesep '(7)SPL' filesep 'results' filesep];
save([filename 'Paras_' Data '_Res.mat'],...
    'precision1','precision2','precision3','precision4','precision5','precision6','precision7',...
    'precision8','precision9','sigRange','delRange','lamRange','sum_precision1','sum_precision2',...
    'sum_precision3','sum_precision4','sum_precision5','sum_precision6','sum_precision7','sum_precision8','sum_precision9');
T2=clock;
DispTime(T1,T2);

%% Plot figures and save
figure(1);
hold on; box on; set(gca, 'fontsize', 16); 
set(gca,'linewidth',2,'fontsize',20,'fontname','Times');
plot(sigRange,precision1(1,:),'--b^',sigRange,precision2(1,:),'-ro',sigRange,precision3(1,:),'-m*','MarkerSize',12,'LineWidth',2);
legend('LR-GN','SPL-GN','BSPL-GN','location','Best'); 
xlabel({'$\sigma$'},'Interpreter','latex','fontsize',24);
ylabel('Accuracy','fontsize',20);
ylim([0,100]);
saveas(gcf,[filename 'sigma_' Data '.fig']);

figure(2);
hold on; box on; set(gca, 'fontsize', 16); 
set(gca,'linewidth',2,'fontsize',20,'fontname','Times');
plot(delRange,precision4(1,:),'--b^',delRange,precision5(1,:),'-ro',delRange,precision6(1,:),'-m*','MarkerSize',12,'LineWidth',2);
legend('LR-DN','SPL-DN','BSPL-DN','location','Best'); 
xlabel({'$\delta$'},'Interpreter','latex','fontsize',24);
ylabel('Accuracy','fontsize',20);
ylim([0,100]);
saveas(gcf,[filename 'delta_' Data '.fig']);

figure(3);
hold on; box on; set(gca, 'fontsize', 16); 
set(gca,'linewidth',2,'fontsize',20,'fontname','Times');
% plot(lamRange,precision7(1,:),'--b^',lamRange,precision8(1,:),'-ro',lamRange,precision9(1,:),'-m*','MarkerSize',12,'LineWidth',2);
% legend('LR-L2','SPL-L2','BSPL-L2','location','Best'); 
plot(lamRange,precision7(1,:),'--b^','MarkerSize',12,'LineWidth',2);
legend('LR-L2','location','Best'); 
xlabel({'$\gamma$'},'Interpreter','latex','fontsize',24);
ylabel('Accuracy','fontsize',20);
ylim([0,100]);
saveas(gcf,[filename 'lambda_' Data '.fig']);
% figure(2);
% plot(Krange,precision1(2,:),'-r^',Krange,precision2(2,:),'-bo','LineWidth',2);
% legend('BMSC','Mean Shift','location','Best'); 
% xlabel({'$\alpha$'},'Interpreter','latex','fontsize',20);
% ylabel('ARI','fontsize',16);
% saveas(gcf,[filename Data '_Eps_' num2str(Eps) '_K_band_ARI.fig']);
% 
% figure(3);
% plot(Krange,precision1(3,:),'-r^',Krange,precision2(3,:),'-bo','LineWidth',2);
% legend('BMSC','Mean Shift','location','Best'); 
% xlabel({'$\alpha$'},'Interpreter','latex','fontsize',20);
% ylabel('NMI','fontsize',16);
% saveas(gcf,[filename Data '_Eps_' num2str(Eps) '_K_band_NMI.fig']);
% 
