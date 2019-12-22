function [trialIdx, BDM, sideOfTrial, finalAmount, endowmentReturn] = BEH_WTP_BDM(nTrials, trialOrder, responses, maxLimit)
    % This function defines which amount of points the participant will gain
    %% ARGUMENTS
    BDM = NaN;
    sideOfTrial = NaN;
    trialIdx = randsample(1:nTrials, 1); % one trial is randomly selected
    %% MAIN FUNCTION
    if ~isnan(responses.meanPrice(trialIdx))
        BDM = randsample(1:maxLimit, 1); % the price for a this trial is randomly generated
        if responses.meanPrice(trialIdx) >= BDM
            % if the mean price > BDM, the participant buys the right to play the lottery
            trials = WTP_trials_conversion(trialOrder.trials);
            sideOfTrial = randsample([1 2], 1); % one of the two numbers of the trial is randomly chosen
            finalAmount = maxLimit - BDM + trials(trialIdx, sideOfTrial);
            endowmentReturn = 0;
        else
            % if the mean price < BDM, the participant keeps only the endowment of 150 points
            finalAmount = maxLimit;
            endowmentReturn = 0;
        end
    else
        % if the participant has not provided both minimal and maximal prices, he/she does not gain
        % anything
        finalAmount = 0;
        endowmentReturn = 1;
    end
end