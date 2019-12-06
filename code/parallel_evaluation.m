function parallel_evalution(data_order)
%load('dataname.mat')
%====================set parameters============================
dataname = {'AustralianCredit.mat','Biodeg.mat','brain.mat','CNAE-9.mat','colon.mat','Iris.mat',...
  'ORL-32x32.mat','Protein.mat','TwoLeadECG.mat','Yale-32x32.mat'};
dataname = cellstr(dataname);
dataset=dataname(data_order); 
%dataname = cellstr(["BreastTissue.mat"]);
%dataset=dataname(1);
iteration = 10; 
%pair_ratio_range = [0.2:0.2:2];
%sub_database_num_range =[10,20,30,40,50]; 
%select_ratio_range = [0.1:0.1:0.5]; 
pair_ratio_range = [1];
sub_database_num_range =[20]; 
select_ratio_range = [0.3]; 
% selected_num = 5; 
%================================================================



%=====================set operating system ======================
parentpath = cd(cd('..')); 
OS = computer; 
% comfirm the type of operating system 
if strcmp(OS,'PCWIN64')
    seperator = '\';
elseif strcmp(OS,'MACI64')
    seperator = '/';
else 
    fprintf('default as Windows operating system');
    seperator = '\'; 
end
datadir = strcat(parentpath,seperator,dataset); 
%=================================================================

%========================= select database ========================
% delete_index = [];
% for i = 1:length(datadir)
%     load(datadir{i});
%     [n,m]=size(fea);
%     clear fea; 
%     clear gnd;
%     if n>=2000 || m>=3000
%         delete_index=[delete_index,i]; 
%     end
% end
% 
% if ~isempty(delete_index)
%     datadir(delete_index)=[]; 
% end
%=================================================================
evaluation={'pair_ratio','sub_database_num','selectio_ratio','AR','RI','MI','HI','NMI','time','n','m'};
iteration_matrix = NaN([iteration,length(evaluation)]);
% the matrix containing the result of every iteration 
evaluation_matrix = NaN([length(datadir)*length(select_ratio_range)*...
    length(sub_database_num_range)*length(pair_ratio_range),length(evaluation)]);
% the matrix containing the average experiment result 
iteration_record = NaN([iteration*length(dataset)*length(select_ratio_range)*...
    length(sub_database_num_range)*length(pair_ratio_range),length(evaluation)]);
% the matrix containing all the result of every iteration 


count = 1; 
for i=1:length(datadir)
    load(datadir{i});
    
    [n,f]=size(fea); 
    clear fea;
    clear gnd; 
    for d=1:length(sub_database_num_range)
        sub_database_num = sub_database_num_range(d);
        for m = 1:length(pair_ratio_range)
            pair_ratio = pair_ratio_range(m);

            for s =1:length(select_ratio_range)
                iteration_matrix = NaN([iteration,length(evaluation)]);
                select_ratio = select_ratio_range(s);
                j=1;
                bad_iteration = 0; 
                while(j<=iteration)
                    try
                        tstart=tic;
                        [AR,RI,MI,HI,NMI] = performance_evaluation(datadir{i},pair_ratio,sub_database_num,select_ratio,j);
                        time_spend = toc(tstart);
                        iteration_matrix(j,:)= [pair_ratio,sub_database_num,select_ratio,AR,RI,MI,HI,NMI,time_spend,n,f];
                        
                        fprintf('finished %d th dataset with %d * %d in the %d iteration \n',i,n,f,j); 
                        fprintf('sub_database_num: %d\n',sub_database_num);
                        fprintf('pair_ratio:%.2f\n',pair_ratio);
                        fprintf('select_ratio: %.2f\n',select_ratio);
                        fprintf('this dataset have spent %.2f second\n',time_spend);
                        
                        save('workspace.mat','iteration_matrix','i','d','m','s');
                        j=j+1; 
                    catch
                        bad_iteration = bad_iteration+1;        
                        fprintf(' bad in the %d iteration\n',j);
                        if bad_iteration >5 
                            break; 
                        end 
                    end
                end
                evaluation_score = nanmean(iteration_matrix,1);
                evaluation_matrix(count,:) = evaluation_score;
                iteration_record(iteration*(count-1)+1:count*iteration,:)=iteration_matrix; 
                save('evaluation_matrix.mat','evaluation_matrix');
                save('iteration_record.mat','iteration_record');
                count=count+1;
            end 
        end 
    
    end
end 


table = array2table(evaluation_matrix,'VariableNames',evaluation);
row_num = 1;
data_name= cell([1,size(evaluation_matrix,1)]);
for i = 1:length(dataset)
    for j = 1:length(pair_ratio_range)*length(select_ratio_range)*length(sub_database_num_range)
        data_name(row_num) = dataset(i);
        row_num = row_num+1;
    end 
end
data_name = reshape(data_name,[size(data_name,2),1]);
table.name = data_name;
writetable(table,'result.csv');


iteration_table = array2table(iteration_record,'VariableNames',evaluation);
row_num = 1; 
data_name = cell([1,size(iteration_record,1)]);
for i = 1:length(datadir)
    for j = 1 : length(sub_database_num_range)*length(select_ratio_range)*length(pair_ratio_range)*iteration
        data_name(row_num) = dataset(i);
        row_num = row_num + 1;
    end 
end 
data_name = reshape(data_name,[size(data_name,2),1]);
iteration_table.name = data_name; 
writetable(iteration_table,'iteration_record.csv')
%cd('..'); % back to the parent folder 
