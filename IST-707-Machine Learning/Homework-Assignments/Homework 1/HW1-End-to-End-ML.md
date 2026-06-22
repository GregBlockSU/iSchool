# Homework Assignment 1: End-to-End Machine Learning

Your goal this week is to perform an end-to-end ML analysis for the "Bank Marketing" dataset, predicting the "y" feature. You will create a Jupyter notebook with the following sections.  

## Sections

1. **EDA**
	- Understand the columns.
	- Examine data visually.
	- Run any additional numeric tests.

2. **Data Preparation**
	- Handle nulls.
	- Scale variables as necessary.
	- Encode variables as necessary.
	- Drop features you don't want.
	- Generate additional features if you want.

3. **Model Selection**
	- For this problem, I'd like you to try two models:
	  - A `DecisionTreeClassifier`
	  - An `SGDClassifier`

4. **Evaluation**
	- Use a cross validation scorer with 5-fold cross validation to determine accuracy for both models.

5. **Tuning**
	- Use `GridSearchCV` to tune the best of the two classifiers above. Use 3-fold cross-validation to save time, and test at least 9 parameter combinations.

6. **Conclusion**
	- This is just a markdown section. Report your best model and it's performance. Provide two or three ideas for how we might further improve our predictions.

Each section must be delineated by a markdown block that marks the section and explains your general approach and major findings. The above are *required* sections, but I welcome additional sub-sections to help provide additional detail.

## Goal

As with all data analytic projects, you need to read the meta-data (bank-names.txt). The meta data has a bit of guidance on how to build a _realistic_ model. This is what I'd like you to do.

The goal of this assignment is to perform end-to-end ML on a fresh dataset. You may not get very good performance, and that's ok! I'm not grading on performance, but instead whether or not you have successfully performed the steps involved in an end-to-end ML assignment. You should *not* sink many hours into this assignment - at most, 4 hours, and hopefully quite a bit less (2.5 would be ideal). This means you should strive to reuse code that's been provided in the lecture notebooks, rather than writing things from scratch.

## Dataset

This dataset is related to direct marketing campaigns of a Portuguese banking institution. It is available here and can be found online (["Bank Marketing" dataset](https://archive.ics.uci.edu/ml/datasets/Bank+Marketing) ) in the **UCI Machine Learning Repository**. The data here contains a “sample" file, which is a random subset you might want to use for initial exploration (but you don't have to), "bank-names.txt" which offers a description of the features (meta data) and "bank-full.csv". Though a large dataset, you shouldn't encounter any serious problems running a model here. 

## Rubric

1. Did you address each of items in the 6 sections above.
2. Is your Jupyter notebook well formatted and free from errors. Does it include well written answers, free of grammatical and spelling errors.