%% BEHAVIOURAL STUDY %%
% Set up input and output variables
general_folder = 'C:\Users\nsidor\Desktop\Scientific_programming_NSidorenko\';
scripts_folder = dir(fullfile(general_folder, '**', 'Scripts')).folder; cd(scripts_folder);
sb_folder = dir(fullfile(general_folder, '**', 'Subjects\BEH')); sb_folder = sb_folder.folder;
session = '1';
n = 66;
for s = 1:n
    BEH_wrapper_WTP_design(general_folder, sb_folder, s, session);
end


% Arguments for running
subject_id = '00002'; % please start with the subject 00002, since the subject 0001 has already been processed
session = '1';
general_folder = 'C:\Users\nsidor\Desktop\Scientific_programming_NSidorenko\';
scripts_folder = dir(fullfile(general_folder, '**', 'Scripts')).folder; cd(scripts_folder);

% Running the training session
BEH_wrapper_WTP_training(subject_id, session, general_folder, []);
% Running the task
BEH_wrapper_WTP_task(subject_id, session, general_folder, []);
% Runing the data analysis
BEH_wrapper_WTP_Data_analysis(subject_id, session, general_folder)