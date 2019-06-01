function constraint = get_pc(file_name,pair_ratio,data,iteration)
    OS = computer; 
    if strcmp(OS,'PCWIN64')
        pattern = '(?<=Ensemble-Clustering\\)[\w\W]+(?=\.mat)'; 
        seperator = '\';
    elseif strcmp(OS,'MACI64')
        pattern = '(?<=Ensemble-Clustering\/)[\w\W]+(?=\.mat)';
        seperator = '/';
    else 
        fprintf('default as Windows operating system');
        pattern = '(?<=Ensemble-Clustering\\)[\w\W]+(?=\.mat)'; 
        seperator = '\'; 
    end
    data_name = regexp(file_name,pattern,'match'); 
    parentpath = cd(cd('..'));
    constraint_name = strcat(parentpath,seperator,data_name{1},num2str(pair_ratio),num2str(iteration),'.mat');
    if exist(constraint_name) == 2
        load(constraint_name);
    else
        constraint=generate_pc(pair_ratio,data); 
        save(constraint_name,'constraint'); 
    end 
end 
