function WTP_task_slider_bar(windowHandle, colors, leftTick, rightTick, tickHeight, horzLine, lineWidth, arrowSize, minPrice, maxPrice)
    % This function should be called inside BEH_WTP_task.m
    
    % Display the standard slide bar with minimal and maximal limit prices
    Screen('DrawLine', windowHandle, colors.scaleColor, leftTick.coord(1), leftTick.coord(2), leftTick.coord(3), leftTick.coord(4), lineWidth);     % Left tick
    Screen('DrawLine', windowHandle, colors.scaleColor, rightTick.coord(1), rightTick.coord(2), rightTick.coord(3), rightTick.coord(4), lineWidth); % Right tick
    Screen('DrawLine', windowHandle, colors.scaleColor, horzLine(1), horzLine(2), horzLine(3), horzLine(4), lineWidth);     % Horizontal line
    DrawFormattedText(windowHandle, leftTick.endPoint, horzLine(1) - leftTick.textBounds(3)*5/4, leftTick.coord(4) - tickHeight/2, colors.textColor); % Left point
    DrawFormattedText(windowHandle, rightTick.endPoint, horzLine(3) + rightTick.textBounds(3)/4, rightTick.coord(4) - tickHeight/2, colors.textColor); % Right point
    
    % Display the selected minimal price
    if ~isempty(minPrice) && isempty(maxPrice)
        Screen('DrawLine', windowHandle, colors.scaleColor, minPrice.Pos, leftTick.coord(2), minPrice.Pos, leftTick.coord(4), lineWidth); % Min Price tick
        DrawFormattedText(windowHandle, minPrice.Str, minPrice.Pos - minPrice.TextBounds(3)/2, horzLine(2) - arrowSize - minPrice.TextBounds(4), colors.textColor); % Min price string
    end
    
    % Display the selected maximal price
    if ~isempty(minPrice) && ~isempty(maxPrice)
        Screen('DrawLine', windowHandle, colors.choiceColor, minPrice.Pos, leftTick.coord(2), minPrice.Pos, leftTick.coord(4), lineWidth); % Min Price
        Screen('DrawLine', windowHandle, colors.choiceColor, maxPrice.Pos, leftTick.coord(2), maxPrice.Pos, leftTick.coord(4), lineWidth); % Max Price
        Screen('DrawLine', windowHandle, colors.choiceColor, minPrice.Pos, horzLine(2), maxPrice.Pos, horzLine(4), lineWidth); % Horizontal line
        DrawFormattedText(windowHandle, minPrice.Str, minPrice.Pos - minPrice.TextBounds(3)/2, horzLine(2) - arrowSize - minPrice.TextBounds(4), colors.choiceColor); % Min price
        if maxPrice.Pos - maxPrice.TextBounds(1)/2 < minPrice.Pos + minPrice.TextBounds(3)
            DrawFormattedText(windowHandle, maxPrice.Str, maxPrice.Pos - maxPrice.TextBounds(3)/2, horzLine(2) + arrowSize + maxPrice.TextBounds(4), colors.choiceColor); % Max price
        else
            DrawFormattedText(windowHandle, maxPrice.Str, maxPrice.Pos - maxPrice.TextBounds(3)/2, horzLine(2) - arrowSize - maxPrice.TextBounds(4), colors.choiceColor); % Max price
        end
    end                
end

 