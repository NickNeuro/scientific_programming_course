function BEH_wrapper_WTP_training(subject_id, session, general_folder, windowHandle)

    %% ARGUMENTS
    folders = struct;
    folders.subject_folder = dir(fullfile(general_folder, '**', 'BEH', '**', ['subject_', subject_id])); folders.subject_folder = folders.subject_folder.folder;
    folders.images_folder = dir(fullfile(general_folder, '**', 'WTP/Trials')); folders.images_folder = folders.images_folder.folder;
    folders.instructions_folder =  dir(fullfile(general_folder, '**', 'WTP/Instructions')); folders.instructions_folder = folders.instructions_folder.folder;
    folders.examples_folder =  dir(fullfile(general_folder, '**', 'WTP/Examples')); folders.examples_folder = folders.examples_folder.folder;
    folders.write_folder = folders.subject_folder;
    
    if isempty(windowHandle)
        windowHandle = BEH_WTP_instructions(folders, []);
    else
        BEH_WTP_instructions(folders, windowHandle);
    end
    [responses, timing, ~] = BEH_WTP_training(subject_id, session, folders, 3, windowHandle);     
    save([folders.write_folder filesep 'SNS_BEH_WTP_training_S', subject_id, '_', session, '.mat'], 'responses', 'timing');
end