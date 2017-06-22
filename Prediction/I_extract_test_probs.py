import numpy as np
import caffe

import os.path
import time
import scipy.io as sio

path = '<PATH_TO_PREDICTION_FOLDER>'
prototxt_file = path + '/test.prototxt';

model = path + '/Best_Performing_Model/best_performing_model';

nClasses = 250;
nSamples = 249506.0;


nBatchSize = 80; ## DO NOT CHANGE BATCH SIZE!!!
## BATCH SIZE NEEDS TO BE 80 
## IF YOUR GPU CANNOT SUPPORT THE BATCH SIZE PLEASE CONTACT THE PARTICIPANT TO 
## ADJUST THE CODE FOR YOUR REQUIREMENTS.

nBatches = np.ceil(nSamples / nBatchSize).astype(int);

GPU_ID = 2;

net = [];
net = caffe.Net(prototxt_file, model);
net.set_phase_test();
net.set_mode_gpu();
net.set_device(GPU_ID);
net.forward(); 
# THIS FORWARD IS FOR SETTING THE NETWORK UP.
# !!THE INPUT LIST NEEDS TO HAVE DUMMY DATA FOR THE FIRST nBatchSize LINES

frame_probabilities = np.zeros((nBatchSize * nBatches,nClasses));

output_file = path + '/test_probs';

if os.path.isfile(output_file) == False:
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
