rm -rf data/output/*
data/tesseract/src/training/tesstrain.sh --fonts_dir data/fonts \
	     --fontlist \
	     --lang tam \
	     --linedata_only \
		 --noextract_font_properties \
		 --training_text data/langdata/tam/tam.training_text \
	     --langdata_dir data/langdata \
	     --tessdata_dir data/tessdata \
	     --save_box_tiff \
	     --maxpages 1000 \
	     --output_dir data/output

#the max pages will enter the amount of pages to be rendered for training purpose