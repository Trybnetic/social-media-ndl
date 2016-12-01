# Predicting political parties based on the language of their socal media activities

## Abstract
In this article we investigated if political parties can be distinguished by the language of their social media activities. We used a simple two-layer neuronal network to predict political parties by their social media posts. The neuronal network was trained on the facebook posts of eight German parties with a simple Naive Discriminative Learning rule.  
A cross-validation analysis revealed good accuracy of the predictions for all political parties and additionally showed that the accuracies for the different parties are not homogeneous. A post-hoc analysis of the most activating cues revealed that the best predictors for each party are the names of famous politicians. Furthermore, the post-hoc analysis of the vector semantics of the model showed different patterns of the activation of the cues for two parties.

## Structure
This project is structured into three parts. The first part is preprocessing and consists of an R-Script (R Core Team, 2016) which extracts the important informations from the output files of facepager (Keyling & Jünger). The python script preprocess.py preprocesses these preselected informations to an eventfile event\_file.tab which must be copied to model/data/.  
In the model folder the steps are specified in training.R which mainly runs the cross-validation by training a ndl2 (Arrpe et al., 2015) model on subsets of all events where each training 1000 events were left out. The result of the cross-validation is saved in activations.rda which needs to be copied to analysis/data/.  
In analysis the analysis.R script specifies the analysis of the results and plots some results to analysis/plots/.

NOTE: We used this structure over putting all scripts in one folder with one script sourcing them all, because with this structure it is easier to obtain overview over the project.
