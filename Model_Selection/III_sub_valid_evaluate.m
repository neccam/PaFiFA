file_prefix = 'Sub_Validation_Probs/sub_valid_parsed_probs_';

minIteration = 1000;
maxIteration = 40000;
iterationStep = 1000;

minThreshold = 0;
maxThreshold = 0.95;
thresholdStep = 0.05;

acc = [];
thresholds = minThreshold:thresholdStep:maxThreshold;
iterations = minIteration:iterationStep:maxIteration;

save_folder = 'Sub_Validation_Predictions';

if ~exist(save_folder,'dir')   
    mkdir(save_folder);
end

pred_mode = 'sum';

for iter = 1:numel(iterations)
    
    curr_file=  [file_prefix, num2str(iterations(iter)), '.mat'];
    load(curr_file);
    
    for th = 1:numel(thresholds)
        curr_acc = 0;
        for i = 1:numel(Labels)
            if isequal(pred_mode,'sum')
                [Labels(i).pred]  =  segment_sum_prob(Labels(i).probs, Labels(i).nFrames, thresholds(th));
            else
                [Labels(i).pred]  =  segment_max_prob(Labels(i).probs, Labels(i).nFrames, thresholds(th));
            end
            curr_acc = curr_acc +  measure_acc(Labels(i).pred, Labels(i).LabelVec);
        end
        acc(iter, th) = curr_acc / numel(Labels);
        
        filename =[save_folder, '/sub_valid_pred_',num2str(iter),'_',num2str(th),'.txt'];
        write_pred(Labels, filename);
    end
end
