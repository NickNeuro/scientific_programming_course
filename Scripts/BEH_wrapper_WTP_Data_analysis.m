function BEH_wrapper_WTP_Data_analysis(subject_id, session, general_folder)
    %% ARGUMENTS
    folders = struct;
    folders.subject_folder = dir(fullfile(general_folder, '**', 'BEH', '**', ['subject_', subject_id])); folders.subject_folder = folders.subject_folder.folder;
    folders.images_folder = dir(fullfile(general_folder, '**', 'WTP/Trials')); folders.images_folder = folders.images_folder.folder;
    folders.write_folder = folders.subject_folder;
    trialOrder = load([folders.subject_folder filesep 'SNS_BEH_WTP_set_S', subject_id, '_', session, '.mat']);    
    subject_responses = load([folders.subject_folder filesep 'SNS_BEH_WTP_task_S', subject_id, '_', session, '.mat']);
    
    BEH_WTP_Data_analysis(folders.subject_folder, trialOrder, subject_responses);
end