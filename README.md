# PaFiFA

## Required Software 
* FFMPEG - *[sudo apt-get install ffmpeg]*.
* C3D Caffe Build - Facebook's Old 3D Convolution Caffe Build. You need to download and compile it. You also need to compile pycaffe *[make pycaffe]* [Link: https://github.com/facebook/C3D/tree/249ab8453be4b213e1068412e290b355997b68d2].
* Matlab & Python.

## Data Preparation
* First thing you need to do is to extract frames from the videos using the *[congd_convert_to_frames.m]* script.
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
* The output of the training will be written to a file in *Logs* subfolder. You can watch the progress of training with the command *[tail -f <Logs/LOG_FILE_NAME>]*.
* The training will run for 40k iterations. The duration might change depending on your GPU and disk access speed. 
* You require 12 GB VRAM [We used a single Titan X GPU for training].

# Model Selection (Evaluation on Validation Set)

# Evaluation on Test Set

#### For any question or problem with the code please contact me via e-mail [see profile].
