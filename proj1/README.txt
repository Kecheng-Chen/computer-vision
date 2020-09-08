How to run this code?

I separate the code in main.m into several parts using %%. You could check the comment to see the use of each part.

If jpg is inputted, run the parts named "start", "For jpg, if not please skip" and "show the output". If tif is inputted, run the parts named "start", "For tif, if not please skip" and "show the output".

Default metric used here is NCC, but you could uncomment other metric like SSD, Canny edge detector and image gradient. Remember for NCC, the higher the score is the better alignment effect you would get, so max1 and max2 are set to be -2, and logical judgements are score1>max1 and score2>max2. But for other metric, please change max1 and max2 to be 2 and logical judgements to be score1<max1 and score2<max2. Variable pynum represents the level of the pyramid.

If you want to check the process like cropping, white balancing, edge detection and image gradient, please look at the following parts based on the comment. Besides, contrast balance and enhancement is done in the part named "start".