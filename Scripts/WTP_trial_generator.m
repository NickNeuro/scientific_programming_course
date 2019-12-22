% This script generates Lottery images for the training session based on the provided Excel file
trials = dir(fullfile('C:\Users\nsidor\Desktop\Scientific_programming_NSidorenko\', '**', 'RISKGARP.xlsx')); trials = [trials.folder filesep trials.name];
trials = table2array(readtable(trials));
folder_to_save = 'C:\Users\nsidor\Desktop\Scientific_programming_NSidorenko\WTP\Trials';
if ~exist(folder_to_save, 'dir')
    mkdir(folder_to_save);
end

for  i = 1:2:size(trials, 2)
    for k = 1:size(trials,1)
        file_name = [folder_to_save filesep num2str(trials(k,i)) '_' num2str(trials(k,i+1)) '.png'];
        file_name_inv = [folder_to_save filesep num2str(trials(k,i+1)) '_' num2str(trials(k,i)) '.png'];
        if ~exist(file_name, 'file') && ~exist(file_name_inv, 'file')
            fig = figure('visible', 'off');
            fig.Color = [0.5 0.5 0.5];
            fig.InvertHardcopy = 'off';
            x = [0.5, 0.5];
            labels = {num2str(trials(k,i)), num2str(trials(k,i+1))};
            explode = [0 1];
            trial = pie(x, explode, labels);
            trial(1).FaceColor = [35, 155, 86]./255;
            trial(2).FontSize = 30;
            trial(2).Position = 0.5*trial(2).Position;
            trial(2).HorizontalAlignment = 'center';
            trial(2).Color = [200 200 200]./255;
            trial(3).FaceColor = [53, 77, 229]./255;
            trial(4).FontSize = 30;
            trial(4).Position = 0.5*trial(4).Position;
            trial(4).HorizontalAlignment = 'center';
            trial(4).Color = [200 200 200]./255;
            %set(gca, 'color', [117 117 177]./255)
            saveas(gcf, file_name);
            %Image resizing
%             I = imread(file_name);
%             J = imresize(I, 0.45);
%             imwrite(J, file_name);
        end
    end
end


