minIteration = 1000;
maxIteration = 40000;
iterationStep = 1000;

prob_file_prefix = 'Sub_Validation_Probs/sub_valid_probs_';
save_file_prefix = 'Sub_Validation_Probs/sub_valid_parsed_probs_';

for iteration = minIteration:iterationStep:maxIteration
    Labels = [];
    load Mats/Sub_Validation.mat
    
    curr_probs = [prob_file_prefix, num2str(iteration), '.mat'];
    curr_save =  [save_file_prefix, num2str(iteration), '.mat'];
    
    if exist(curr_probs,'file') && (~exist(curr_save,'file'))
        
        frame_probabilities = load(curr_probs);
        frame_probabilities = frame_probabilities.frame_probabilities;

        for i = 1:numel(Labels)
            prob_idx = 1:Labels(i).nFrames-15;
            Labels(i).probs = frame_probabilities(prob_idx,:);
            frame_probabilities(prob_idx,:) = [];
        end

        save(curr_save, 'Labels');
    end
end