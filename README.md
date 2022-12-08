# Adapting the Tesseract Open-Source OCR Engine for Tamil and Sinhala Legacy Fonts and Creating a Parallel Corpus for Tamil-Sinhala-English

![project] ![research]



- <b>Project Mentor</b>
    1. Dr.Uthayasanker Thayasivam
- <b>Contributor</b>
    1. Charangan Vasantharajan
    2. Laksika Tharmalingam

---

## Summary

This research is about developing a simple, and automatic OCR engine that can extract text from  documents (with legacy fonts usage and printer-friendly encoding which are not optimized for text extraction) to create a parallel corpus. 

For this purpose, we enhanced the performance of Tesseract 4.1.1 by employing LSTM-based training on many legacy fonts to recognize printed characters in the above languages. Especially, our model detects code-mix text, numbers, and special characters from the printed document.

## Description

This project consists of the following.

- Dataset
- Model Training
- Model
- Improvements
- Corpus Creation

### Dataset
We created box files with coordinates specification, and then, we rectified misidentified characters, adjusted letter tracking, or spacing between characters to eliminate bounding box
overlapping issues using jTessBoxEditor.

<p align="center">
<img src="https://github.com/aaivu/Tamizhi-Net-OCR/blob/master/docs/jTessBoxEditor.png" width="600">
</p>

The following instructions will guide to generate TIFF/Box files. 

```
tesstrain.sh --fonts_dir data/fonts \
	     --fontlist \
	     --lang tam \    
	     --linedata_only \
		 --noextract_font_properties \
		 --training_text data/langdata/tam/tam.training_text \
	     --langdata_dir data/langdata \
	     --tessdata_dir data/tessdata \
	     --save_box_tiff \
	     --maxpages 100 \
	     --output_dir data/output
```


### Model Training
The table illustrates the command line flags used during the training. We have finalized the below
numbers after conducting several experiments with different values.

| Flag  | Value |
| ------------- | ------------- |
| traineddata  | path of traineddata file that contains the unicharset, word dawg, punctuation pattern dawg, number dawg  |
| model_output   | path of output model files / checkpoints  |
| learning_rate  | 1e-05  |
| max_iterations  | 5000  |
| target_error_rate | 0.001 |
| continue_from  | path to previous checkpoint from which to continue training.  |
| stop_training  | convert the training checkpoint to full traineddata.  |
| train_listfile  | filename of a file listing training data files.  |
| eval_listfile  | filename of a file listing evaluating data files.  |


The following instructions will guide to start training.

```
OMP_THREAD_LIMIT=8 lstmtraining \
	--continue_from data/model/tam.lstm \
	--model_output data/finetuned_model/ \
	--traineddata data/tessdata/tam.traineddata \
	--train_listfile data/output/tam.training_files.txt \
	--eval_listfile data/output/tam.training_files.txt \
	--max_iterations 5000
```

### Performance Evaluation
In this analysis, we consider two metrics to evaluate OCR output, namely Character Error Rate (CER) and Word Error Rate (WER).

- Tamil


| Font | No. of Chrs | Original Tesseract | | | Fine-tuned Tesseract | | |
| - | - | - | - | - | - | - | - |
| | | RC | CER (%) | WER (%) | RC | CER (%)| WER (%) |
| Aabohi | 757 | 757 | 0.19 | 2.67 |  757 | 0.19 | 2.67| 
| AnbeSivam | 762 | 774 | 7.87 | 57.89  | 765 | 2.71 | 31.58| 
| Baamini | 762 | 770 | 7.44 | 56.26 |  762 | 2.42 | 31.58 |  
| Eelanadu | 762 | 773 | 4.88 | 43.42 | 763 | 0.58 | 9.21 | 
| Kamaas | 762 | 756 | 3.38 | 28.95 |  766 | 0.43 | 9.21| 
| Keeravani | 767 | 764 | 0.68 | 13.16  | 764 | 0.19 | 1.32| 
| Kilavi | 762 | 767 | 0.48 |9.21 |  763 | 0.14 | 2.63|  
| Klaimakal | 762 | 765 | 0.82 | 14.47  | 766 | 0.48 | 3.95| 
| Tamilweb | 762 | 808 | 20.39 | 88.89 |772 | 11.13 | 67.90| 
| Nagananthini | 762 | 783 | 14.2 | 82.89  | 785 | 7.83 | 46.05| 
| - | - | - | - | - | - | - | - |
| Mean | || 6.03 | 39.68 |  | 2.61 | 20.61|

- Sinhala


| Font | No. of Chrs | Original Tesseract | | | Fine-tuned Tesseract | | |
| - | - | - | - | - | - | - | - |
| | | RC | CER (%) | WER (%) | RC | CER (%)| WER (%) |
| Bhasitha  | 731 | 701 | 25.97 | 84.62 | 725 |8.73 | 46.15|
| BhashitaComplex  | 731 | 728 | 5.11 | 27.35  | 731 | 3.94 | 23.08|
| Bhasitha2Sans | 731 | 726 | 4.68 | 23.93 |  730 | 3.88 | 22.22|
| Bhasitha Screen | 731 | 726 | 4.79 | 24.79 | 729 | 3.99 | 23.93|
| Dinaminal Uni Web  | 731 | 728 | 5.64 | 29.91  | 731 | 4.52 | 22.22|
| Hodipotha & 731 | 726 | 6.07 | 35.90  |  729 | 4.10 | 24.79|
| Malithi Web & 731 | 718 | 6.01 | 34.19  | 726 | 4.74 | 29.91|
| Noto Sans Sinhala  | 731 | 730 | 3.94 |23.08  | 732 |3.73 | 21.37 |
| Sarasavi Unicode  | 731 | 709 | 9.10 | 38.46  | 728 | 5.64 | 27.35|
| Warna & 731 | 726 | 4.74 | 28.21 |  732 | 4.10 | 24.79|
| - | - | - | - | - | - | - | - | 
| Mean | || 7.61 | 35.04 |  | 4.74 | 26.58 |

### Model
The architecture of PCR is shown below. As the first step, we detect the file type and convert it to images if the input file is PDF. Then images are binarized and then image character boundary detection techniques are applied to find character boxes. Finally, deep learning modules identify word and line boundaries first then the characters are recognized. Finally using a language model, post-processing the file. 


<p align="center">
<img src="https://github.com/aaivu/Tamizhi-Net-OCR/blob/master/docs/tamizhi-net.png", width="1000">
</p>


### Corpus Creation
 To create a parallel corpus, we used [www.parliament.lk](www.parliament.lk) website to download the required PDFs of all three languages and feed them into our model to get extracted texts. 

- Corpus statistics


| Language |No. of Files | No. of Sentences | No. of Words | No. of Unique Words | Total Sentences |
| - | - | - | - | - | - |
| Tamil | 100 | 185.4K | 2.11M |334.16K | 45.3MB |
| Sinhala | 100 | 168.9K | 2.22M | 407.99K | 35.7MB |
| English | 100 | 181.04K | 2.33M | 372.03K | 20.8MB|


### Cite this work

```
@INPROCEEDINGS{9961304, 
    author={Vasantharajan, Charangan and Tharmalingam, Laksika and Thayasivam, Uthayasanker},
    booktitle={2022 International Conference on Asian Language Processing (IALP)}, 
    title={Adapting the Tesseract Open-Source OCR Engine for Tamil and Sinhala Legacy Fonts and Creating a Parallel Corpus for Tamil-Sinhala-English}, 
    year={2022},
    volume={}, 
    number={}, 
    pages={143-149}, 
    doi={10.1109/IALP57159.2022.9961304}
}
```

### License

Apache License 2.0

### Code of Conduct

Please read our [code of conduct document here](https://github.com/aaivu/aaivu-introduction/blob/master/docs/code_of_conduct.md).

[project]: https://img.shields.io/badge/-Project-blue
[research]: https://img.shields.io/badge/-Research-yellowgreen
