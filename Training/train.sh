BASE_MODEL="<PATH_TO_TRAINING_FOLDER>/Base_Model/baseline_model"

SOLVER="<PATH_TO_TRAINING_FOLDER>/solver.prototxt"

EXECUTABLE="<PATH_TO_C3D_BUILD>/build/tools/finetune_net.bin"

now=$(date +%Y%m%d_%H%M%S)

GLOG_logtostderr=1 "$EXECUTABLE" "$SOLVER" "$BASE_MODEL" > "Logs/train_log_"$now".txt" 2>&1
