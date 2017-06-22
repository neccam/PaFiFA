prob_file = 'test_probs.mat';
save_file = 'test_parsed_probs.mat';

Labels = [];
load Mats/Test.mat
        
frame_probabilities = load(curr_probs);
frame_probabilities = frame_probabilities.frame_probabilities;

for i = 1:numel(Labels)
    prob_idx = 1:Labels(i).nFrames-15;
    Labels(i).probs = frame_probabilities(prob_idx,:);
    frame_probabilities(prob_idx,:) = [];
end

save(curr_save, 'Labels');
