function BEH_WTP_Data_analysis(subject_folder, trialOrder, subject_responses)
    % Data preparation
    trials = WTP_trials_conversion(trialOrder.trials);  
    meanPrice = mean([subject_responses.responses.minPrice, subject_responses.responses.maxPrice], 2);
   
    % Figure 1
    figure;
    histogram(meanPrice, 'FaceColor', '#009999', ...
                         'EdgeColor', '#006600', ...
                         'BinWidth', 10);
    grid on;
    ylim([0, 5]);
    xlabel('Mean Reservation Price', 'FontSize', 14);
    ylabel('Frequency', 'FontSize', 14);
    title('{\it What is the most current Reservation Price?}', 'FontSize', 14);
    
    saveas(gcf, [subject_folder filesep 'Mean Reservation Price frequency.png']);
    close(gcf);

    % Figure 2
    figure;
    scatter(abs(trials(1:numel(meanPrice),1) - trials(1:numel(meanPrice),2)), meanPrice)
    reg_line = lsline;
    set(reg_line, 'Color', '#006633', 'LineWidth', 1)
    grid on;
    xlabel('Absolute difference between two proposed gains', 'FontSize', 14);
    ylabel('Mean Reservation Price', 'FontSize', 14);
    title('{\it Reservation Price as function of absolute difference}', 'FontSize', 14);
    legend('Mean Price', 'Regression line')
    saveas(gcf, [subject_folder filesep 'Reservation Price as funcition of absolute difference.png']);
    close(gcf);
end