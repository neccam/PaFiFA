import numpy as np
import caffe

import os.path
import time
import scipy.io as sio

model_path = '<PATH_TO_MODEL_FILES[TRAINING/MODELS]>'
path = '<PATH_TO_MODEL_SELECTION>';

prototxt_file = path + '/sub_valid.prototxt';
model_prefix = 'pafifa_iter_';

nClasses = 250;
nSamples = 32000.0;
nBatchSize = 80;
nBatches = np.ceil(nSamples / nBatchSize).astype(int);

GPU_ID = 2;

output_path = 'Sub_Validation_Probs'

for iteration in range(1000, 41000, 1000):
    
    print model_prefix + str(iteration)
    model = model_path + '/' + model_prefix + str(iteration)
    
    if os.path.isfile(model) == True:
        
        output_file = path + '/' + output_path + '/sub_valid_probs_' + str(iteration);
        if os.path.isfile(output_file + '.mat') == False:
            
            net = [];
            net = caffe.Net(prototxt_file, model);
            net.set_phase_test();
            net.set_mode_gpu();
            net.set_device(GPU_ID);
            net.forward(); 
            # This forward is for setting network up. 
            # !!The input list needs to have dummy data for the first nBatchSize Lines
        
            frame_probabilities = np.zeros((nBatchSize * nBatches,nClasses));
        
            dummy = np.zeros((5,5));
            sio.savemat(output_file, {"dummy" : dummy});
            
            beginTime = time.time();
            for b in range(0, nBatches):
                net.forward();
                frame_probabilities[b*80:(b+1)*80,:] = np.squeeze(net.blobs['prob'].data);
                                    
                elapsed = time.time() - beginTime;
                print("Current Model File: " + model_prefix + str(iteration) + " Processed {} batches in {:.2f} seconds. " "{:.2f} seconds/iteration.".format((b+1), elapsed, elapsed/(b+1)))
                time.sleep(.001)
                                    
                
            beginTime = time.time()
            sio.savemat(output_file, {"frame_probabilities" : frame_probabilities})
            elapsed = time.time() - beginTime;
            print("Current Model File: " + model + " Saved Probs in {:.2f} seconds.".format(elapsed))
