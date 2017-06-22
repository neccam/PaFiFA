import sys
sys.path.insert(0, 'Utils');

import tools
import jaccard_index as ji
import numpy as np

results = np.zeros((40,20));

for it in range(1,41):
    for th in range (1,21):
        
        file_name = 'Sub_Validation_Predictions/sub_valid_pred_' + str(it) + '_' + str(th) + '.txt';
#        print file_name
        gt_table, js_table = tools.read_ground_truth('Mats/sub_valid_gt.txt')
        p_table, _ = tools.read_ground_truth(file_name)
        for video in p_table:
            ps = p_table[video]
            gts = gt_table[video]
            labels = set()
            g_labels = set()
            for seg in gts:
                _, l = seg
                labels.add(l)
                g_labels.add(l)
            for seg in ps:
                _, l = seg
                labels.add(l)
            sum_jsi_v = 0.
            for label in labels:
                jsi_value = ji.Jsi(gts, ps, label)
                sum_jsi_v += jsi_value
            Js = sum_jsi_v / len(g_labels)
            js_table[video] = Js
        
        mean_JS = sum(js_table.values()) / float(len(js_table))
        results[it-1,th-1] = mean_JS;
        print mean_JS

ind = np.unravel_index(np.argmax(results),results.shape)
print 'BEST PERFORMING PARAMETERS: [USE THESE PARAMETERS FOR PREDICTION PHASE]'
print 'ITERATION: ' + str((ind[0]+1)*1000)
print 'THRESHOLD: '+ str(ind[1]*0.05)
