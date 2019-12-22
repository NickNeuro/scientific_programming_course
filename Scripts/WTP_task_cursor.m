function WTP_task_cursor(windowHandle, colors, currPrice, horzLine, arrowSize, x, minPrice)
    % Display the cursor and the current price
    % This function should be called inside BEH_WTP_task.m
    if ~isempty(x) && ~isempty(minPrice)
        if x - currPrice.TextBounds(1)/2 < minPrice.Pos + minPrice.TextBounds(3)
            DrawFormattedText(windowHandle, currPrice.Str, x - currPrice.TextBounds(3)/2, horzLine(2) + arrowSize + currPrice.TextBounds(4), colors.textColor); % curr max price
        else
            DrawFormattedText(windowHandle, currPrice.Str, x - currPrice.TextBounds(3)/2, horzLine(2) - arrowSize - currPrice.TextBounds(4), colors.textColor); % curr max price
        end
    else
        DrawFormattedText(windowHandle, currPrice.Str, currPrice.Pos - currPrice.TextBounds(3)/2, horzLine(2) - arrowSize - currPrice.TextBounds(4), colors.textColor); % current price
    end
    Screen('FillPoly', windowHandle, colors.arrowColor, [currPrice.Pos - arrowSize, horzLine(2) - arrowSize;
                                                         currPrice.Pos, horzLine(2);
                                                         currPrice.Pos + arrowSize, horzLine(2) - arrowSize]);
end