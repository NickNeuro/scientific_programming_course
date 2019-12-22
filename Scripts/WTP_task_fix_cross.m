function WTP_task_fix_cross(windowHandle, colors, centerX, centerY, lineWidth)
    % Display the fixation cross
    % This function should be called inside BEH_WTP_task.m
    Screen('DrawLine', windowHandle, colors.scaleColor, centerX - lineWidth*3, centerY, centerX + lineWidth*3, centerY, lineWidth);
    Screen('DrawLine', windowHandle, colors.scaleColor, centerX, centerY - lineWidth*3, centerX, centerY + lineWidth*3, lineWidth);
end