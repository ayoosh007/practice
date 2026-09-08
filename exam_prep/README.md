# ML lab exam practice

Six runnable notebooks with short versions of the lab procedures. All six were
executed from fresh kernels on 8 September 2026. Data is included, so none needs
internet once the Python packages are installed. Open a notebook in this folder
and choose **Restart Kernel and Run All Cells**.

## What to practise typing

Learn the sequence: **load -> prepare X/y -> split -> preprocess -> fit ->
predict -> evaluate**. Lab 1 stops after preprocessing. Lab 6 uses a small
training dataset for a numerical demonstration.

| Notebook | Main sequence | Include when requested |
|---|---|---|
| [Lab 1](Lab1_EDA_pipeline.ipynb) | Inspect, clean, EDA, date parts, split, encode/scale | Requested plots and interpretation |
| [Lab 2](Lab2_MLR_scratch.ipynb) | Sections 1–6: covariance/correlation, split/scale, normal equation, GD, metrics | Section 7: original-unit equation and plots |
| [Lab 3](Lab3_DecisionTrees.ipynb) | Missing zeros, split/train medians, entropy/gini classifiers, metrics | Manual criteria, tree drawings/rules, pruning, Part B regression/depth study |
| [Lab 4](Lab4_SVM.ipynb) | Petal features, split/scale, three kernels, compare | Boundary helper/plots, C/gamma studies, support-vector details |
| [Lab 5](Lab5_Regularization.ipynb) | Split/scale, four models, penalties, coefficients, metrics | IQR/correlation and extra EDA plots |
| [Lab 6](Lab6_LogisticRegression_scratch.ipynb) | Scale, sigmoid, GD, predict, manual metrics, new-data prediction | Section 6: first-update arithmetic check |

These are study routes. Follow every requirement on the exam paper.
Report formatting, image exports and repeated presentation tables are omitted.
Use plain loops and one statement per line. Practise rebuilding each notebook in
a blank file, then add the plots or checks specified in the question.

## Source alignment and checks

| Prep | Original notebook | Checked result |
|---|---|---|
| Lab 1 | `../24BAI1370_Riverside_City_Data_Detective.ipynb` | Clean numeric/category values match the saved cleaned CSV; 360 rows, no missing; transformed train/test 288×28 / 72×28 |
| Lab 2 | `../lab 2/24BAI1370_Lab2.ipynb` | Manual covariance/correlation include the target; both methods give test RMSE 0.636 and R² 0.904; coefficient difference below 0.000001 |
| Lab 3 | `../lab 3/24BAI1370_Lab3.ipynb` | Information gain, gain ratio and Gini gain match source tables; entropy tree depth 4, 13 leaves; Glucose regression test RMSE 26.616 |
| Lab 4 | `../lab 4/24BAI1370_Lab4.ipynb` | Linear/poly/RBF test accuracy 0.9333 / 0.9778 / 0.9333; support-vector counts 24 / 26 / 30 |
| Lab 5 | `../Wine_Quality_Regularization_clean.ipynb` | All four models match rerun source coefficients/predictions; Ridge alpha 100, Lasso alpha 0.0052, ElasticNet alpha 0.0139 and l1_ratio 0.5 |
| Lab 6 | `../LogisticRegFlow.png` and `../ClassificationMetrics.png` | Gradients checked numerically; first-step gradient [-0.4364, -0.0407], new weights [0.2182, 0.0203] at learning rate 0.5 |

Lab 6 has no original lab notebook in this workspace. It follows the two reference
images, including new-data prediction and all their listed classification metrics.
Its 100% accuracy is on the eight training examples, not a held-out test score.

The three previously bundled datasets are byte-for-byte copies of the source lab
files. Riverside is the source notebook's generated practice dataset.
`winequality-red.csv` is a local copy of the
[UCI red-wine CSV](https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv)
used by the wine notebook (1599 rows, 12 columns).

## Details to remember

- Lab 1 follows the original full-data EDA cleaning. Only the encoder/scaler are
  fitted after splitting. For leakage-free predictive evaluation, learn medians,
  modes and IQR bounds from training data too.
- Lab 2 uses the source settings: learning rate 0.5, up to 200000 GD iterations,
  tolerance 1e-10. Strongly correlated predictors make convergence slow. Keep the
  leading ones column. The inverse formula assumes a full-rank design matrix.
- Lab 3's "ID3" means the source's entropy-based sklearn comparison. sklearn uses
  binary CART even with entropy. The manual table searches nine percentile
  thresholds; it is not the tree's internal split search.
- Lab 4 uses **petal length and petal width**. Test-set comparisons of kernels,
  depths and parameters in these labs are exploratory. Use validation/CV for
  model selection before a final test evaluation.
- Lab 5 preserves scaling before internal CV, as in the source. The test set stays
  separate, but strictly isolated CV needs scaling inside each fold. The source
  reports duplicates/outliers without dropping them.
- Lab 6 uses confusion-matrix order `[1, 0]`, matching the image. Lab 3 uses
  sklearn's `[0, 1]` order. The formulas are the same; the positions differ.

## Run from a terminal

From the project root, using the existing environment:

```bash
.venv/bin/python -m jupyter nbconvert --to notebook --execute --inplace exam_prep/*.ipynb
```

Verified with NumPy 2.5.1, pandas 3.0.5 and scikit-learn 1.9.0, plus matplotlib,
seaborn, openpyxl and Jupyter. Minor formatting may differ with other versions.
