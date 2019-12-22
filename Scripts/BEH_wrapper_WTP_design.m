function BEH_wrapper_WTP_design(general_folder, sb_folder, s, session)
%%%% This function create a dataset for WTP task

%%%% Inputs %%%%
% 'general_folder' = the whole path to the folder with the all the files required to run the task
% 'sb_folder' = the whole path to the folder where a subject folder will be stored
% 's' = subject number (string)
% 'session' = session number (integer)

%%%% Outputs %%%%
% a .mat file containing the dataset for a given subject.
% This dataset represents the order of the lottery images
% According to the design of the task, the same lottery will be viewed twice.
% Thus, to specify the number of trials in each run, please change the value of the variable
% 'numberOfTrials' on the line 46
% The final dataset will contain the double of this value.

        %% Set up a folder where the dataset will be stored
        if s > 0 && s <= 9
            disp(s);
            subject_id = ['0000', num2str(s)];
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        elseif s > 9 && s <= 99
            disp(s);
            subject_id = ['000', num2str(s)];
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        elseif s > 99
            disp(s);
            subject_id = ['000', num2str(s)];
            subject_folder = [sb_folder filesep 'subject_', subject_id];
            if ~exist(subject_folder, 'dir')
                mkdir(subject_folder);
            end
        end
        
        %% Create a dataset
        filename = [subject_folder filesep 'SNS_BEH_WTP_set_S', subject_id, '_', session, '.mat'];
        trials_dir = dir(fullfile(general_folder, '**', 'WTP/trials'));
        trials_temp = {};
        numberOfTrials = 109; % maximal number is 109
        i = 1; j = 1;
        while j <= numberOfTrials
            if contains(trials_dir(i).name, '.png')   
                trials_temp{j} = trials_dir(i).name; 
                j = j + 1;
            end
            i = i + 1;
        end
        trials_temp = trials_temp(~cellfun('isempty',trials_temp)); % eliminate empty cells
        if isempty(trials_temp)
            error(['Please create a folder with .png images representing the lotteries! ' ...
                   'Check the function BEH_WTP_trial_generator']);
        end 
        if ~exist(filename, 'file')
            trials = BEH_WTP_design(trials_temp);
            save(filename, 'trials');
            disp(['Subject ' num2str(s) ' has been processed for the WTP task']);
        else
           writeover = input(['WTP task dataset for subject ' num2str(s) ' already exists, do you want to overwrite? 1 = yes, 0 = no ', '\n']);
           if writeover
               trials = BEH_WTP_design(trials_temp);
               save(filename, 'trials');
               disp(['Subject ' num2str(s) ' has been processed for the WTP task']);
           end % end of overwriting
        end % end of if loop
end % end of function