function BEH_wrapper_WTP_task(subject_id, session, general_folder, windowHandle)

    %% ARGUMENTS
    folders = struct;
    folders.subject_folder = dir(fullfile(general_folder, '**', 'BEH', '**', ['subject_', subject_id])); folders.subject_folder = folders.subject_folder.folder;
    folders.images_folder = dir(fullfile(general_folder, '**', 'WTP/Trials')); folders.images_folder = folders.images_folder.folder;
    folders.write_folder = folders.subject_folder;
    trialOrder = load([folders.subject_folder filesep 'SNS_BEH_WTP_set_S', subject_id, '_', session, '.mat']);

    if isempty(windowHandle)
        [responses, timing, ~] = BEH_WTP_Task(subject_id, session, folders, trialOrder, 20, []);
    else
        [responses, timing, ~] = BEH_WTP_Task(subject_id, session, folders, trialOrder, 20, windowHandle);
    end
    save([folders.write_folder filesep 'SNS_BEH_WTP_task_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
end