function trials = WTP_trials_conversion(trialOrderCell)
% This function makes conversion of the dataset cell array into an array of integers 
    trials = zeros(numel(trialOrderCell), 2);    
    for i = 1:numel(trialOrderCell)
        firstElement = strsplit(trialOrderCell{i}, '_'); 
        trials(i,1) = str2num(firstElement{1});
        trials(i,2) = str2num(firstElement{2}(1:end-4));
    end
end