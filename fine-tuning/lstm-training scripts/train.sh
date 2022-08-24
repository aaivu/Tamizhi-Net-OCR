rm -rf data/finetuned_model/*
OMP_THREAD_LIMIT=8 lstmtraining \
	--continue_from data/model/tam.lstm \
	--model_output data/finetuned_model/ \
	--traineddata data/tessdata/tam.traineddata \
	--train_listfile data/output/tam.training_files.txt \
	--eval_listfile data/output/tam.training_files.txt \
	--max_iterations 5000
