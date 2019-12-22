function windowHandle = BEH_WTP_instructions(folders, windowHandle)

%%%% This function displays both instructions and control questions
% If one of the control questions is answered wrong, the participant will be asked to 
% raise his/her hand. The study investigator will come and answer the eventual questions.
% To continue the task afterwards, just press 'm' on the keyboard
%% KEYBOARD
KbName('UnifyKeyNames');
to_right = KbName('RightArrow'); 
answer_a = KbName('a');
answer_b = KbName('b');
answer_c = KbName('c');
answer_d = KbName('d');
move_on = KbName('m'); % m for move on (nothing to do with the Alfred Hitchcock's movie). 
                       % moreover, that's unlikely for the participant to press 'm' by chance and
                       % thus continue the task without calling the study investigator

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

% Colors and text
colors = struct;
colors.textColor = [200 200 200]; % off white
colors.scaleColor = [200 200 200];
colors.arrowColor = [200 200 200];
colors.choiceColor = [255 255 0];
textSize = round(screenHeight/36); % 30 when full screen mode
wrapat_length = round(screenHeight/10);
Screen('TextFont', windowHandle,'Arial');
Screen('TextSize', windowHandle, textSize);

%% INSTRUCTIONS - PART I
instructions{1} = ['In this task you will play a lottery. \n' ... 
                   'In each trial you will be presented two numbers:'];
               
instructions{2} = ['For each trial you need to indicate the MINIMUM and MAXIMUM prices you are willig to pay ' ...
                   'to SECURE your RIGHT to play the lottery. For doing so, you will have 6 seconds of time and an endowment of 150 points. ' ...
                   'You can use this all the points or only a part of them to give BOTH prices. \n\n' ...
                   'To continue, please press the RIGHT ARROW on the keyboard.'];
               
imageMatrix = double(imread([folders.examples_folder filesep 'example_1.png' ])); 
[imageHeight, imageWidth, ~] = size(imageMatrix); 
imageTexture = Screen('MakeTexture', windowHandle, imageMatrix);

[~, ~, textBounds, ~] = DrawFormattedText(windowHandle, instructions{1}, 'center', screenHeight/10, colors.textColor, wrapat_length, [], [], 2);
imageRect = [centerX - imageWidth/3, textBounds(4), centerX + imageWidth/3, textBounds(4) + imageHeight*0.75]; % Lottery image
Screen('DrawTexture', windowHandle, imageTexture, [], imageRect);
DrawFormattedText(windowHandle, instructions{2}, centerX/4, imageRect(4), colors.textColor, wrapat_length, [], [], 2);
Screen('Flip', windowHandle);
check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && any(key_code(to_right))
        check = 0;
    end
end

%% INSTRUCTIONS - PART II
instructions{1} = ['PURPOSE: at the end of the task ONE trial will be randomly selected. ' ...
                   'If you have indicated BOTH minimum and maximum prices, a MEAN price will be calculated ' ...
                   'and then the computer will generate a random price between 1 and 150 points. ' ...
                   'As in every auction, your mean price will be compared to the generated price. \n\n' ...
                   'If your price is HIGHER or EQUAL to the generated price, you will "buy" the right to play the lottery ' ...
                   'and will receive for sure "150 - generated price" points. \n' ...
                   'If your mean price is SMALLER than the generated price, you will only keep 150 points. \n' ...
                   'However, if you have NOT indicated BOTH prices (i.e. the mean price can not be calculated), you will get nothing.' ...
                   'Thus it is in your own best interest to give as many valid answers as possible. \n\n' ...
                   'To continue, please press the RIGHT ARROW on the keyboard.'];
               
instructions{2} = ['LOTTERY: if your mean price is high enough to buy the right to play the lottery, ' ...
                   'the computer will randomly select ONE of the two numbers presented in the bought trial ' ...
                   'and you will get that amount of points IN ADDITION to what you spare with buying the right to play the lottery. \n\n' ...
                   'Please note that there is NO WAY OF GAMING the auction, ' ...
                   'the BEST thing that you can do in every trial is to imagine that you have 150 points to spend '...
                   'and ask yourself what are the MINIMUM and MAXIMUM prices you would be willing to pay to buy the right to get one of the numbers displayed in the circle. \n' ...
                   'Remember that the auction price is NOT determined by your mean price but randomly. ' ...
                   'Thus, lowering your mean price DOES NOT ALTER the price that you pay when you win the auction, ' ...
                   'but may cost you the opportunity to win EVEN MORE points through the lottery. \n\n' ...
                   'To continue, please press the RIGHT ARROW on the keyboard.'];

DrawFormattedText(windowHandle, instructions{1}, centerX/4, 'center', colors.textColor, wrapat_length, [], [], 2);
Screen('Flip', windowHandle);
WaitSecs(1);
check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && any(key_code(to_right))
        check = 0;
    end
end

DrawFormattedText(windowHandle, instructions{2}, centerX/4, 'center', colors.textColor, wrapat_length, [], [], 2);
Screen('Flip', windowHandle);
WaitSecs(1);
check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && any(key_code(to_right))
        check = 0;
    end
end

%% INSTRUCTIONS - CONTROL QUESTIONS
%%%%% First question
instructions{1} = ['CONTROL QUESTION 1 \n\n' ...
                   'Let assume your MEAN price for the trial "10 - 130" is 60. \n' ...
                   'What happens if the computer generates a price of 50 for this trial at the end of the task? \n\n' ...
                   'a) I will definitely win 130 points \n' ...
                   'b) I will get 150 - 50 = 100 points for sure and then also either 10 or 130 points as the outcome of the bought lottery \n' ...
                   'c) I will get only 150 points \n' ...
                   'd) I will get nothing \n\n' ...
                   'Please press the letter that corresponds to your answer on the keyboard'];

DrawFormattedText(windowHandle, instructions{1}, centerX/4, 'center', colors.textColor, wrapat_length, [], [], 2);
Screen('Flip', windowHandle);

raise_hand = false;
check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && (any(key_code(answer_a)) || any(key_code(answer_b)) || any(key_code(answer_c)) || any(key_code(answer_d)))
        check = 0;
        if ~any(key_code(answer_b))
            raise_hand = true;
        end
    end
end
WaitSecs(1);

%%%%% Second question
instructions{1} = ['CONTROL QUESTION 2 \n\n' ...
                   'Let assume your MEAN price for the trial "10 - 130" is 60. \n' ...
                   'What happens if the computer generates a price of 70 for this trial at the end of the task? \n\n' ...
                   'a) I will get nothing \n' ...
                   'b) I will get only 150 points \n' ...
                   'c) I will get 150 - 50 = 100 points for sure and then also either 10 or 130 points as the outcome of the bought lottery \n' ...
                   'd) I will definitely win 130 points \n\n' ...
                   'Please press the letter that corresponds to your answer on the keyboard'];

DrawFormattedText(windowHandle, instructions{1}, centerX/4, 'center', colors.textColor, wrapat_length, [], [], 2);
Screen('Flip', windowHandle);

check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && (any(key_code(answer_a)) || any(key_code(answer_b)) || any(key_code(answer_c)) || any(key_code(answer_d)))
        check = 0;
        if ~any(key_code(answer_b))
            raise_hand = true;
        end
    end
end
WaitSecs(1);

%%%%% Third question
instructions{1} = ['CONTROL QUESTION 3 \n\n' ...
                   'Let assume you have given only the minimal price for the trial "10 - 130" and this price is equal to 30. \n' ...
                   'What happens if the computer generates a price of 15 for this trial at the end of the task? \n\n' ...
                   'a) I will definitely win 130 points \n' ...
                   'b) I will get 150 - 50 = 100 points for sure and then also either 10 or 130 points as the outcome of the bought lottery \n' ...
                   'c) I will get only 150 points \n' ...
                   'd) I will get nothing \n\n' ...
                   'Please press the letter that corresponds to your answer on the keyboard'];

DrawFormattedText(windowHandle, instructions{1}, centerX/4, 'center', colors.textColor, wrapat_length, [], [], 2);
Screen('Flip', windowHandle);

check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && (any(key_code(answer_a)) || any(key_code(answer_b)) || any(key_code(answer_c)) || any(key_code(answer_d)))
        check = 0;
        if ~any(key_code(answer_d))
            raise_hand = true;
        end
    end
end
WaitSecs(1);

% If one of the answers is wrong
if raise_hand
    DrawFormattedText(windowHandle, 'Please raise your hand', 'center', 'center', colors.textColor, wrapat_length, [], [], 2);
    Screen('Flip', windowHandle);
    
    check = 1;
    while check
        [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
        if key_is_down && any(key_code(move_on))
            check = 0;
        end
    end    
end
WaitSecs(1);


%% INSTRUCTIONS - PART III
instructions{1} = ['To give the MIN and MAX prices you are willing to pay for securing the lottery, ' ...
                   'you will have to select them on the slide bar. Please FIRST select the minimum price. ' ...
                   'To do so, DRAG the MOUSE along the slide bar and CLICK on the LEFT BUTTON of the MOUSE, when you want to confirm your choice: '];
instructions{2} = ['After that please select the maximum price. ' ...
                   'To do so, DRAG the MOUSE again along the slide bar and CLICK on the LEFT BUTTON of the MOUSE to confirm your choice: '];
instructions{3} = '\n To continue, please press the RIGHT ARROW on the keyboard';
minPriceBarMatrix = double(imread([folders.instructions_folder filesep 'minPriceSlideBar.bmp' ]));
maxPriceBarMatrix = double(imread([folders.instructions_folder filesep 'maxPriceSlideBar.bmp' ])); 
[imageHeight, imageWidth, ~] = size(minPriceBarMatrix); % assume that all the images have the same dimensions
minPriceBarTexture = Screen('MakeTexture', windowHandle, minPriceBarMatrix);
maxPriceBarTexture = Screen('MakeTexture', windowHandle, maxPriceBarMatrix);

[~, ~, textBounds, ~] = DrawFormattedText(windowHandle, instructions{1}, centerX/4, screenHeight/10, colors.textColor, wrapat_length, [], [], 2);
imageRect = [centerX - imageWidth/2, textBounds(4), centerX + imageWidth/2, textBounds(4) + imageHeight];
Screen('DrawTexture', windowHandle, minPriceBarTexture, [], imageRect);
[~, ~, textBounds, ~] = DrawFormattedText(windowHandle, instructions{2}, centerX/4, imageRect(4) + 40, colors.textColor, wrapat_length, [], [], 2);
imageRect = [centerX - imageWidth/2, textBounds(4), centerX + imageWidth/2, textBounds(4) + imageHeight]; 
Screen('DrawTexture', windowHandle, maxPriceBarTexture, [], imageRect);
DrawFormattedText(windowHandle, instructions{3}, centerX/4, imageRect(4) + 40, colors.textColor, wrapat_length, [], [], 2);
Screen('Flip', windowHandle);

WaitSecs(1);
check = 1;
while check
    [key_is_down, ~, key_code] = KbCheck; % check whether a key is pressed and which one 
    if key_is_down && any(key_code(to_right))
        check = 0;
    end
end


end