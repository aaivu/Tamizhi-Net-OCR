## Installing Tesseract on Ubuntu

Before you start building tesseract latest from source, you need to install few dependencies. First, you have to install the leptonica library, its a pedagogically-oriented open source library containing software that is broadly useful for image processing and image analysis applications

To install leptonica, use the following command:
```bash
    $ sudo apt-get install -y libleptonica-dev
```
    
Use the following commands to install the other dependencies:
```bash
    $ sudo apt-get update -y
    $ sudo apt-get install automake
    $ sudo apt-get install -y pkg-config
    $ sudo apt-get install -y libsdl-pango-dev
    $ sudo apt-get install -y libicu-dev
    $ sudo apt-get install -y libcairo2-dev
    $ sudo apt-get install bc
```
    
The last library bc is an extra dependency that is required to get tesseract 5 running on your machine.
Now you have to clone the tesseract repository. Hey! but stop right there! First, go to the following repository:
https://github.com/tesseract-ocr/tesseract
    
```bash
    $ wget https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.1.0.zip
```
    
You can download either zip or tar.gz file. Here I have downloaded the zip file. You can unzip the file to your current directory using unzip command:
```bash
    $ unzip tesseract-5.1.0.zip
```
    
Upon the completion of unzip operation, a folder titled tesseract-5.1.0 has been created. Get into this directory using cd command.
```bash
    $ cd tesseract-5.1.0
```
    
You need to run the following commands from the tesseract-5.1.0 directory to install the tesseract:
```bash
    $ ./autogen.sh 
    $ ./configure 
    $ make 
    $ sudo make install
    $ sudo ldconfig 
    $ make training 
    $ sudo make training-install 
```
    
To check that tesseract has been installed successfully, run the following command:
```bash
    $ tesseract --version
```    
