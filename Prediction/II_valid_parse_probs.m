prob_file = 'valid_probs.mat';
save_file = 'valid_parsed_probs.mat';

Labels = [];
load Mats/Valid.mat
        
frame_probabilities = load(prob_file);
frame_probabilities = frame_probabilities.frame_probabilities;

for i = 1:numel(Labels)
    prob_idx = 1:Labels(i).nFrames-15;
    Labels(i).probs = frame_probabilities(prob_idx,:);
    frame_probabilities(prob_idx,:) = [];
end

save(curr_save, 'Labels');
