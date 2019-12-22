function [responses, timing, windowHandle] = BEH_WTP_Task(subject_id, session, folders, trialOrder, nTrials, windowHandle)

% This function allows to do the main task
%%%% Inputs %%%%
% 'subject_id' = subject number (string). Ex.: '00001' or '00059'
% 'session' = session number (string). Ex. : '1'
% 'folders' = a structure containing paths to the subject folder, folder with example images, images
% for the instructions and the folder where the outcome should of the function should be written.
% 'trialOrder' = a cell array containing the names of the lottery images to be presented in the task
% 'nTrials' = number of trials (integer). Ex. : 20. Please be aware the nTrials should be smaller than or
% equal to the length of the provided dataset 'trialOrder'.
% 'windowHandle' : window pointer. Ex. : 10. This argument should be given only if the PTB screen has 
% already been open by another function. If that's not the case, do not specify 'windowHandle' as
% argument when calling the current function.

%%%% Output %%%%
% 'responses' = structure containing the responses of the subject
% 'timing' = structure containing the timing of the subject
% 'windowHandle' : window pointer (may be used afterwards to execute another function on the same
% screen)

% Check variables
if  exist('subject_id', 'var') && exist('session', 'var') && exist('folders', 'var') && exist('trialOrder', 'var') && exist('nTrials', 'var')
    if ischar(subject_id) && ischar(session) && isstruct(folders) && isstruct(trialOrder) && isnumeric(nTrials) 
        % Output file
        responses_file_name = [folders.write_folder filesep 'SNS_BEH_WTP_task_S', subject_id, '_', session, '.mat'];

        % Check to prevent overwriting previous data
%         file_existence = exist([responses_file_name '.mat'], 'file');
%         if file_existence
%             writeover = input('Filename already exists, do you want to overwrite? 1 = yes, 0 = no ');
%         else
%             writeover = 2; % no messages necessary
%         end
% 
%         switch writeover
%             case 0
%                 subject_id = input('Enter proper subject ID as text string: ');
%                 responses_file_name = [folders.write_folder filesep 'SNS_BEH_WTP_task_S', subject_id, '_', session, '.mat'];
%             case 1
%                 disp('responses file will be overwritten')
%         end
%         clear file_existence writeover
    else
        error('Your arguments are not valid');
    end
else
    error('You did not provide enough arguments');
end

%%%% PREPARATIONS %%%%
%% TIMING VARIABLES
waitingForTrial = 1; % ITI
priceSelectionTime = 6; % seconds for selecting both minimal and maximal prices

%% KEY BOARD
KbName('UnifyKeyNames');
to_right = KbName('RightArrow'); 

%% OUTPUT VARIABLES
responses = struct; % responses variable 
timing = struct; % timing variable
responses.minPrice = NaN(nTrials,1); 
responses.maxPrice = NaN(nTrials,1);
responses.meanPrice = NaN(nTrials,1);
responses.startMinPrice = NaN(nTrials,1);
responses.startMaxPrice = NaN(nTrials,1); 
timing.trial_minStart_time = NaN(nTrials,1); 
timing.minDecision_time = NaN(nTrials,1); 
timing.minReaction_time = NaN(nTrials,1); 
timing.trial_maxStart_time = NaN(nTrials,1); 
timing.maxDecision_time = NaN(nTrials,1); 
timing.maxReaction_time = NaN(nTrials,1); 
timing.loopTimer = NaN(nTrials,1);

%% IMAGES
images_folder = folders.images_folder;
% Transforme the Lottery images into matrices
imageMatrix = cell(nTrials, 1); % Lottery images
for currImage = 1:nTrials
    imageMatrix{currImage, 1} = double(imread([images_folder filesep trialOrder.trials{currImage}])); 
end

%% SCREEN
% Recognize the screen
if ~exist('windowHandle', 'var')
    [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
    %[windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2, [0 0 700 800]); % debugging mode
end
if exist('windowHandle', 'var') && isempty(windowHandle)
    [windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2); % full screen
    %[windowHandle, ~] = Screen('OpenWindow', max(Screen('Screens')), [255 255 255]/2, [0 0 700 800]); % debugging mode
end

HideCursor;


% Determine dimensions of the opened screen
[screenWidth, screenHeight] = Screen('WindowSize', windowHandle);
centerX = floor(0.5 * screenWidth);
centerY = floor(0.5 * screenHeight);

% Colors and text
colors = struct;
colors.textColor = [200 200 200]; % off white
colors.scaleColor = [200 200 200];
colors.arrowColor = [200 200 200];
colors.choiceColor = [255 255 0]; % yellow
textSize = round(screenHeight/36); % ~30 when full screen mode
Screen('TextFont', windowHandle,'Arial');
Screen('TextSize', windowHandle, textSize);

%% Slider
% Parameters
leftTick = struct;
rightTick = struct;
middleTick = struct;
minLimit = 0; % left border of the slider bar
maxLimit = 150; % right border of the slider bar
gap = 0; % minimal interval between min and max price. In the current version it is set up as 0 but other values are also possible depending on the task design
leftTick.endPoint = [num2str(minLimit) ' points'];
rightTick.endPoint = [num2str(maxLimit) ' points'];
middleTick.meanPoint = 'Mean : 00'; % '00' is specified to obtaining text bounds for a two-digit price
Screen('TextSize', windowHandle, textSize);
leftTick.textBounds = Screen('TextBounds', windowHandle, leftTick.endPoint); 
rightTick.textBounds = Screen('TextBounds', windowHandle, rightTick.endPoint);
middleTick.textBounds = Screen('TextBounds', windowHandle, middleTick.meanPoint);
scaleLength = screenWidth/3; % slider bar length
tickHeight = abs(leftTick.textBounds(1,4) - leftTick.textBounds(1,2)); % half-height of ticks
scaleResFactor = scaleLength/(maxLimit - minLimit); % slider bar resolution in pixels
arrowSize = screenHeight/54; % arrow size, ~20 when full screen mode

% Coordinates
[imageHeight, imageWidth, ~] = size(imageMatrix{1,1}); % assume that all the images have the same dimensions
imageRect = [centerX - imageWidth/2, centerY - imageHeight/2 - 60, centerX + imageWidth/2, centerY - 60 + imageHeight/2]; % Lottery image
leftTick.coord  = [centerX - scaleLength/2, imageRect(4) - tickHeight + 60, centerX - scaleLength/2, imageRect(4) + tickHeight + 60]; % left border of the slider bar
rightTick.coord = [centerX + scaleLength/2, imageRect(4) - tickHeight + 60, centerX + scaleLength/2, imageRect(4) + tickHeight + 60]; % right border of the slider bar
horzLine  = [centerX - scaleLength/2, imageRect(4) + 60, centerX + scaleLength/2, imageRect(4) + 60]; % slider bar
meanPricePos = [centerX - middleTick.textBounds(3)/2, imageRect(4) - 20 - middleTick.textBounds(4)/2];
lineWidth = screenHeight/216; % ~5 when full screen mode

%% TEXTURES
imageTexture = cell(nTrials, 1);
for currImage = 1:nTrials
    imageTexture{currImage, 1} = Screen('MakeTexture', windowHandle, imageMatrix{currImage, 1});
end

%% TASK %%
try
    % initial black out and fixation cross
    WTP_task_fix_cross(windowHandle, colors, centerX, centerY, lineWidth);
    Screen('Flip', windowHandle);
    WaitSecs(waitingForTrial);
    for currTrial = 1:nTrials
        loopTimer = tic();
        %% MINIMAL PRICE SELECTION %%
        % Lottery image
        Screen('DrawTexture', windowHandle, imageTexture{currTrial, 1}, [], imageRect);
        % Slider bar with ticks
        WTP_task_slider_bar(windowHandle, colors, leftTick, rightTick, tickHeight, horzLine, lineWidth, arrowSize, [], []);
        % Cursor
        startMinPrice = struct;
        startMinPrice.Price = randsample(minLimit:maxLimit, 1); % start position for selecting min price
        responses.startMinPrice = startMinPrice.Price;    
        startMinPrice.Pos = startMinPrice.Price*scaleResFactor + leftTick.coord(1); % start position X in pixels
        startMinPrice.Str = num2str(startMinPrice.Price); % price in text format
        startMinPrice.TextBounds = Screen('TextBounds', windowHandle, startMinPrice.Str);
        WTP_task_cursor(windowHandle, colors, startMinPrice, horzLine, arrowSize, [], []); % display the cursor with the start price
        meanPriceStr = ['Mean : ' num2str(startMinPrice.Price)];
        DrawFormattedText(windowHandle, meanPriceStr, meanPricePos(1), meanPricePos(2), colors.textColor); % mean price
        Screen('Flip', windowHandle);

        SetMouse(startMinPrice.Pos, centerY);
        timing.trial_minStart_time(currTrial) = GetSecs;
        minTrial = 0; % false if the minimal price is not selected, true otherwise 
        clear startMinPrice
        while (GetSecs - timing.trial_minStart_time(currTrial) < priceSelectionTime) && ~minTrial
            [x, ~, buttons, ~] = GetMouse(windowHandle);
            if ~buttons(1) % if no price is selected
                % if the pointer reaches borders
                if x > rightTick.coord(1) - gap*scaleResFactor
                    x = rightTick.coord(1) - gap*scaleResFactor;
                elseif x < leftTick.coord(1)
                    x = leftTick.coord(1);
                end

                % Lottery image
                Screen('DrawTexture', windowHandle, imageTexture{currTrial, 1}, [], imageRect);
                % Slider bar with ticks
                WTP_task_slider_bar(windowHandle, colors, leftTick, rightTick, tickHeight, horzLine, lineWidth, [], []);
                % Cursor for minimal price
                currPrice = struct;
                currPrice.Price = round((x - leftTick.coord(1))/scaleResFactor); % current price
                currPrice.Pos = x;
                currPrice.Str = num2str(currPrice.Price); % current price in text format
                currPrice.TextBounds = Screen('TextBounds', windowHandle, currPrice.Str);
                WTP_task_cursor(windowHandle, colors, currPrice, horzLine, arrowSize, [], []); % display the cursor with the current price
                meanPriceStr = ['Mean : ' num2str(currPrice.Price)];
                DrawFormattedText(windowHandle, meanPriceStr, meanPricePos(1), meanPricePos(2), colors.textColor); % mean price
                Screen('Flip', windowHandle);
                clear x buttons currPrice
            else
                timing.minDecision_time(currTrial) = GetSecs;
                timing.minReaction_time(currTrial) = timing.minDecision_time(currTrial) - timing.trial_minStart_time(currTrial);
                if x > rightTick.coord(1) - gap*scaleResFactor
                    x = rightTick.coord(1) - gap*scaleResFactor;
                elseif x < leftTick.coord(1)
                    x = leftTick.coord(1);
                end
                minPrice = struct;
                minPrice.Price = round((x - leftTick.coord(1))/scaleResFactor); % final min price
                responses.minPrice(currTrial) = minPrice.Price;
                minPrice.Pos = x;
                minPrice.Str = num2str(minPrice.Price); % minimal price in text format
                minPrice.TextBounds = Screen('TextBounds', windowHandle, minPrice.Str);

                % Lottery image
                Screen('DrawTexture', windowHandle, imageTexture{currTrial, 1}, [], imageRect);
                % Slider bar with ticks
                WTP_task_slider_bar(windowHandle, colors, leftTick, rightTick, tickHeight, horzLine, lineWidth, arrowSize, minPrice, []);
                % Cursor with the selected minimal price
                meanPriceStr = ['Mean : ' num2str(minPrice.Price)];
                DrawFormattedText(windowHandle, meanPriceStr, meanPricePos(1), meanPricePos(2), colors.textColor); % mean price
                Screen('Flip', windowHandle);
                minTrial = 1;
                WaitSecs(0.5);
                clear x buttons
            end % end of current price selection / if loop
        end % end of minimal price selection / while loop
        clear minTrial

        %% MAXIMAL PRICE SELECTION %%
        if ~isnan(responses.minPrice(currTrial)) && GetSecs - timing.trial_minStart_time(currTrial) < priceSelectionTime
            % Lottery
            Screen('DrawTexture', windowHandle, imageTexture{currTrial, 1}, [], imageRect);
            % Slider bar with ticks and minimal price
            WTP_task_slider_bar(windowHandle, colors, leftTick, rightTick, tickHeight, horzLine, lineWidth, arrowSize, minPrice, []);
            % Start position for maximal price
            if minPrice.Price < maxLimit - gap
                startMaxPrice.Price = randsample((minPrice.Price + gap):maxLimit, 1); % start position for selecting maximal price
            else
                startMaxPrice.Price = maxLimit;
            end
            responses.startMaxPrice = startMaxPrice.Price;    
            startMaxPrice.Pos = startMaxPrice.Price*scaleResFactor + leftTick.coord(1); % start position in pixels
            startMaxPrice.Str = num2str(startMaxPrice.Price); % price in text format
            startMaxPrice.TextBounds = Screen('TextBounds', windowHandle, startMaxPrice.Str);
            WTP_task_cursor(windowHandle, colors, startMaxPrice, horzLine, arrowSize, [], minPrice); % display the cursor with the start price
            meanPriceStr = ['Mean : ' num2str(mean([minPrice.Price, startMaxPrice.Price]))];
            DrawFormattedText(windowHandle, meanPriceStr, meanPricePos(1), meanPricePos(2), colors.textColor); % mean price
            Screen('Flip', windowHandle);

            SetMouse(startMaxPrice.Pos, centerY);
            timing.trial_maxStart_time(currTrial) = GetSecs;
            maxTrial = 0;
            clear startMaxPrice
            while (GetSecs - timing.trial_maxStart_time(currTrial) < priceSelectionTime) && ~maxTrial
                [x, ~, buttons, ~] = GetMouse(windowHandle);
                if ~buttons(1) % if no price is selected
                    % if the pointer reaches borders
                    if x > rightTick.coord(1)
                        x = rightTick.coord(1);
                    elseif x < minPrice.Pos + gap*scaleResFactor
                        x = minPrice.Pos + gap*scaleResFactor;
                    end

                    % Lottery image
                    Screen('DrawTexture', windowHandle, imageTexture{currTrial, 1}, [], imageRect);
                    % Slider bar with ticks and minimal price
                    WTP_task_slider_bar(windowHandle, colors, leftTick, rightTick, tickHeight, horzLine, lineWidth, arrowSize, minPrice, []);

                    % Cursor for maximal price
                    currPrice.Price = round((x - leftTick.coord(1))/scaleResFactor); % current price
                    currPrice.Pos = x;
                    currPrice.Str = num2str(currPrice.Price); % current price in text format
                    currPrice.TextBounds = Screen('TextBounds', windowHandle, currPrice.Str);
                    WTP_task_cursor(windowHandle, colors, currPrice, horzLine, arrowSize, x, minPrice);
                    meanPriceStr = ['Mean : ' num2str(mean([minPrice.Price, currPrice.Price]))];
                    DrawFormattedText(windowHandle, meanPriceStr, meanPricePos(1), meanPricePos(2), colors.textColor); % mean price
                    Screen('Flip', windowHandle);
                    clear x buttons currPrice

                else
                    timing.maxDecision_time(currTrial) = GetSecs;
                    timing.maxReaction_time(currTrial) = timing.maxDecision_time(currTrial) - timing.trial_maxStart_time(currTrial);
                    if x > rightTick.coord(1)
                        x = rightTick.coord(1);
                    elseif x < minPrice.Pos + gap*scaleResFactor
                        x = minPrice.Pos + gap*scaleResFactor;
                    end
                    maxPrice = struct;
                    maxPrice.Price = round((x - leftTick.coord(1))/scaleResFactor); % final min price
                    responses.maxPrice(currTrial) = maxPrice.Price;
                    maxPrice.Pos = x;
                    maxPrice.Str = num2str(maxPrice.Price); % current price in text format
                    maxPrice.TextBounds = Screen('TextBounds', windowHandle, maxPrice.Str);
                    Screen('DrawTexture', windowHandle, imageTexture{currTrial, 1}, [], imageRect);
                    % Slider bar with ticks
                    WTP_task_slider_bar(windowHandle, colors, leftTick, rightTick, tickHeight, horzLine, lineWidth, arrowSize, minPrice, maxPrice);
                    responses.meanPrice(currTrial) = mean([minPrice.Price, maxPrice.Price]);
                    meanPriceStr = ['Mean : ' num2str(mean([minPrice.Price, maxPrice.Price]))];
                    DrawFormattedText(windowHandle, meanPriceStr, meanPricePos(1), meanPricePos(2), colors.choiceColor); % mean price
                    Screen('Flip', windowHandle);
                    WaitSecs(1); % display the recorded answer for the current trial
                    maxTrial = 1;
                    clear x buttons
                end % end of current price selection / if loop
            end % end of maximal price selection / while loop
        end % end of maximal price selection / if loop
        clear maxTrial minPrice maxPrice
        timing.loopTimer(currTrial) = toc(loopTimer);
        if timing.loopTimer(currTrial) < priceSelectionTime % add remaining time to the ITI
            WTP_task_fix_cross(windowHandle, colors, centerX, centerY, lineWidth);
            Screen('Flip', windowHandle);
            WaitSecs(priceSelectionTime - timing.loopTimer(currTrial) + waitingForTrial);
        else
            WTP_task_fix_cross(windowHandle, colors, centerX, centerY, lineWidth);
            Screen('Flip', windowHandle);
            WaitSecs(waitingForTrial);
        end
        save(responses_file_name, 'responses', 'timing');

    end % end of for loop
    
    % Determine the final amount to pay
    [trialIdx, BDM, sideOfTrial, finalAmount, endowmentReturn] = BEH_WTP_BDM(nTrials, trialOrder, responses, maxLimit);
    responses.trialIdx = trialIdx;
    responses.BDM = BDM;
    responses.sideOfTrial = sideOfTrial;
    responses.finalAmount = finalAmount;
    responses.endowmentReturn = endowmentReturn;
    finalAmountStr = ['Your gain is ' num2str(finalAmount*0.1) ' CHF \n\n To continue, please press the RIGHT BUTTON on the keyboard'];
    DrawFormattedText(windowHandle, finalAmountStr, 'center', 'center', colors.textColor); % final amount
    Screen('Flip', windowHandle);
    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(to_right))
            check = 0;
        end
    end
catch
    Screen('CloseAll');
    error('Something went wrong. Please check your code for eventual errors');
end
%% CLOSE DISPLAY
Screen('CloseAll');

end % end of function
