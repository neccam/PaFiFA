addpath('Utils');

prob_file = 'test_parsed_probs.mat';
load(prob_file)

% BEST PERFORMING THRESHOLD VALUE IN OUR EXPERIMENTS
threshold_value = 0.40 

pred_mode = 'sum';


frame_level_acc = 0;
for i = 1:numel(Labels)
	if ~isempty(Labels(i).probs)
	    if isequal(pred_mode,'sum')
		[Labels(i).pred]  =  segment_sum_prob(Labels(i).probs, Labels(i).nFrames, threshold_value);
	    else
		[Labels(i).pred]  =  segment_max_prob(Labels(i).probs, Labels(i).nFrames, threshold_value);
	    end
	    frame_level_acc  = frame_level_acc  +  measure_acc(Labels(i).pred, Labels(i).LabelVec);
	end
end
frame_level_acc = frame_level_acc  / numel(Labels);

filename = 'test_prediction.txt'
write_pred(Labels, filename);

