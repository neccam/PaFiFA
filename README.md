# PaFiFA

## Required Software 
* FFMPEG - *[sudo apt-get install ffmpeg]*.
* C3D Caffe Build - Facebook's Old 3D Convolution Caffe Build. You need to download and compile it. You also need to compile pycaffe *[make pycaffe]* [Link: https://github.com/facebook/C3D/tree/249ab8453be4b213e1068412e290b355997b68d2].
* Matlab & Python.

## Data Preparation
First thing you need to do is to extract frames from the videos using the *[congd_convert_to_frames.m]* script.
* Go to *Extract_Frames_From_Videos* folder.
* Run the *[congd_convert_to_frames.m]* matlab script.
  * Make sure you change **dbPath** and **savePath** in *[congd_convert_to_frames.m]*.
* Will take around 3-5 hours depending on your disk access speed.

# Training Phase
To train our model you need to do the following:
* Go to *Training* folder.
* Go to *Input_List* subfolder and run *[download_input_list.sh]* 
* Go to *Base_Model* subfolder and run *[download_baseline_model.sh]*
* Search and change the variables in the following files:
  * *[Input_List/train.input]*:  **<PATH_TO_EXTRACTED_FRAMES>**
  * *[train.sh]*: **<PATH_TO_TRAINING_FOLDER>** and **<PATH_TO_C3D_BUILD>**
  * *[train.prototxt]*: **<PATH_TO_TRAINING_FOLDER>**
* Go back to *Training* folder and run *[train.sh]*.
* The output of the training will be written to a file in *Training/Logs* subfolder. You can watch the progress of training with the command *[tail -f <Logs/LOG_FILE_NAME>]*.
* The training will run for 40k iterations. The duration might change depending on your GPU and disk access speed. 
* You require 12 GB VRAM [We used a single Titan X GPU for training].

# Model Selection
Our training yields us 40 models, snapshots of our network at every 1000 iterations. To select the best performing model we would evaluate them on the validation set. However, extraction of posteriors from all of the validation videos takes too much time (4+ hours for each model). Instead we select our model by evaluation them on a subset of the validation set.

Here is our evaluation process:
* Go to *Model Selection* folder
* Search and change the variables in the following files:
  * *[Input_List/sub_valid.input]*: **<PATH_TO_EXTRACTED_FRAMES>**
  * *[sub_valid.prototxt]*: **<PATH_TO_MODEL_SELECTION>**
  * *[I_sub_valid_extract_probs.py]*: **<PATH_TO_MODEL_FILES[TRAINING/MODELS]>** and **<PATH_TO_MODEL_SELECTION>**
* Run *[I_sub_valid_extract_probs.py]* python script. This script will extract probabilites from the validation subset for each model. This step will take some time (20 minutes per model x 40 models).
* Run *[II_sub_valid_parse_probs.m]* matlab script. This script will parse the extracted probabilities to a Label structure, which will be used in following steps.
* Run *[III_sub_valid_evaluate.m]* matlab script. This script will create prediction files which will be used to measure jaccard index score. 
* Run *[IV_sub_valid_measure_jaccard_score.py]* python script. This script will provide you the best performing parameters (Best Model [Iteration] and Threshold Value). You will use these parameters to chose your final model. 

# Prediction on Validation and Test Sets
* We now know the best performing model (iteration) from the model selection step. Copy that file from *Training/Models* to the *Prediction/Best_Performing_Model* folder and rename it to *best_performing_model*.

Or you can just run the *[Prediction/Best_Performing_Model/download_best_performing_model.sh]* script to download the model that performed best in our experiments. 

**Note:** As we are using stochastic gradient descent with randomly shuffled data and random weight initialization for some of our layers, thus your best performing model is most likely to be different then ours. In addition to evaluating with your models, please evaluate with our best performing model as well to reproduce our final results. 

* Go To *Prediction* folder
* Search and change the variables in the following files:
  * *[valid/test.prototxt]*: **<PATH_TO_PREDICTION_FOLDER>**
  * *[I_extract_valid/test_probs.py]*: **<PATH_TO_PREDICTION_FOLDER>**
* Run *[I_valid/test_extract_probs.py]* python scripts. These scripts will extract probabilites from the validation/test  sets for the best performing model. This step will take some time (Over 4+ hours for each set).
* Run *[II_valid/test_parse_probs.m]* matlab scripts. These scripts will parse the extracted probabilities to Label structures, which will be used in following steps.
* Run *[III_sub_valid_evaluate.m]* matlab scripts. These scripts will output final prediction files *[valid/test_prediction]* which you can use to measure our jaccard index score.

#### The code was tested on Ubuntu 14.04 machine with CUDA 8.0 and cuDNN 5.0. All of the experiments were done on a single Titan X GPU with 12 GB VRAM. ####

**Note:** As this is a public repository the base model, the training input list and the best performing model links will be activated with the end of the competition (07/02/17 00:00 UCT) to allow code verification.

#### For any question or problem with the code please contact me via e-mail [see profile].
