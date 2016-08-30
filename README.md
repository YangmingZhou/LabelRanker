# LabelRankingLearning
This project includes two state-of-the-art label ranking algorithms, i.e., label ranking with random forest and Gaussian mixture model respectively
# Datasets
Label ranking datasets consist of 16 semisynthetic datasets and 5 realworld datasets, more detail see DatasetInfo.txt.

#Important note: Please make sure that the above paper is cited whenever our code is used in your research.

Our algorithm random forest for label ranking is implemented in Matlab Platform (MATLAB 2014b). For a more detailed description of the RF-LR algorithm, please refer to the original paper.

# Experimental Settings
1. To run the proposed RF-LR algorithm, you need to determine the following parameters in advance:

1). maximum depth of the decision tree (MaxDepth), we set it as 8 in the experiments.
2). total number of decision trees in the forest (NumTree), and we set it as 50 in the experiments.

2. The format of the input file should be as follows (for instance):

-0.55556	0.25000	-0.86441	-0.91667	1	2	3
-0.66667	-0.16667	-0.86441	-0.91667	1	2	3
-0.77778	0.00000	-0.89831	-0.91667	1	2	3
-0.83333	-0.08333	-0.83051	-0.91667	1	2	3
-0.61111	0.33333	-0.86441	-0.91667	1	2	3
...

# Contact Us
Please e-mail (yangming@info.univ-angers.fr, guoping.qiu@nottingham.ac.uk) under any of the following conditions:

You're having trouble running RF-LR
You've found a bug in RF-LR
You have any other questions, comments or suggestions

# Legal Information
The software is distributed for academic puposes only. If you wish to use this software for commercial applications, please obtain the prior permission from Yangming Zhou (yangming@info.univ-angers.fr) and Guoping Qiu (guoping.qiu@nottingham.ac.uk).


