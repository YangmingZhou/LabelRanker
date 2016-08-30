# LabelRanker
This project includes two state-of-the-art label ranking algorithms, i.e., label ranking with random forest (RF-LR) and Gaussian mixture model (LR-GMM) respectively

# References
[1] Yangming Zhou, Yangguang Liu, Xia-Zhi Gao and Guoping Qiu, "A label ranking method based on Gaussian mixture model",Knowledge-Based Systems , 2014, 72, 108 - 113, http://www.sciencedirect.com/science/article/pii/S0950705114003293.

[2] Yangming Zhou and Guoping Qiu, "Random Forest for Label Ranking",2016, http://arxiv.org/abs/1608.07710.

#Important note: Please make sure that the above paper is cited whenever our code is used in your research.

# Datasets
Label ranking datasets consist of 16 semisynthetic datasets and 5 realworld datasets, more detail see DatasetInfo.txt.

Our algorithm random forest for label ranking is implemented in Matlab Platform (MATLAB 2014b). For a more detailed description of the RF-LR algorithm, please refer to the original paper.

# Experimental Settings
To run the proposed RF-LR algorithm, you need to determine the following parameters in advance:

1). maximum depth of the decision tree (MaxDepth), we set it as 8 in the experiments.
2). total number of decision trees in the forest (NumTree), and we set it as 50 in the experiments.

# Contact Us
Please e-mail (yangming@info.univ-angers.fr, guoping.qiu@nottingham.ac.uk) under any of the following conditions:

You're having trouble running RF-LR
You've found a bug in RF-LR
You have any other questions, comments or suggestions

# Legal Information
The software is distributed for academic puposes only. If you wish to use this software for commercial applications, please obtain the prior permission from Yangming Zhou (yangming@info.univ-angers.fr) and Guoping Qiu (guoping.qiu@nottingham.ac.uk).




