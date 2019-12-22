function trials = BEH_WTP_design(trials_temp)
%%%% This function creates the trial order for a given dataset

%%%% Inputs %%%%
% 'trials_temp' = cell array with the names of the lottery images 
% 'trials_temp' = {'0_102.png'} {'0_108.png'} {'0_111.png'} {'0_165.png'} {'0_225.png'} 

%%%% Outputs %%%%
% randomized order of trials

    random_idx_1 = randsample(1:numel(trials_temp), numel(trials_temp));
    random_idx_2 = randsample(1:numel(trials_temp), numel(trials_temp));
    trials = [trials_temp(random_idx_1)'; trials_temp(random_idx_2)'];
end