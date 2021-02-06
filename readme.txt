The code repo consists of 4 folders :

1) Averaging_scripts:  This contains scripts for ‘quanta averaging’ using your code, and ‘naive averaging’.

	•	To extract the binary images from the dump files, first run ‘read.m’. 

	•	From these binary images, use ‘test_0326.m’ to generate quanta averaging images (this is an updated version of test_0326.m from your code-base). Parameter ’N’ and ‘offset’ would allow controlling the averaging window length and overlap between successive windows.

	•	Use ‘readData.py’ to generate naively averaged images. The parameter ‘window’ in code determines the averaging window length.


2) Decolor & BSUV-Net are for background subtraction using PCA and DeepLearning model respectively.

	•	In Decolor, these parameters would require change in file ‘RUN_REAL_STATIC.m:

	⁃	dataName-> experiment name for output file
	⁃	inputdata -> path to averaged images
	⁃	third dimension of ‘ImData’ -> number of image frames
	⁃	indices of for loop-> according to image names

		The result is stored as a video in ‘result’ folder, along with result images in ‘resultImages’ folder

	•	In BSUV-Net, changes would be required mostly in parameters ‘empty_bg’, ‘empty_win_len’, ‘recent_bg’ in file ‘infer_config.py’ (explanatory comments are present). Running instructions are present in this folder’s readme.


3) Mosse tracking is for correlation based tracking
	
	Use mosse.m to run by providing path to background subtracted images. 
