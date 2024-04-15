# Student Performance Analysis Project

## Overview
This project aims to analyze student performance data from two courses, Math (mat) and Portuguese (por), to uncover insights into factors affecting academic success. The analysis explores various dimensions such as socio-economic impacts, behavioral influences, and educational support mechanisms. Through statistical analysis and predictive modeling, this project provides valuable insights for educational institutions to enhance student learning experiences and outcomes.

## Objectives
- **Academic Performance Analysis**: Analyze the influence of study habits, parental education, and extracurricular activities on student grades.
- **Comparative Study**: Compare behavioral patterns and academic performance between students in math and Portuguese courses.
- **Socioeconomic Impact**: Investigate the role of socioeconomic factors in educational achievements.
- **Behavioral Analysis**: Assess how lifestyle choices correlate with academic performance.
- **Predictive Modeling**: Build models to predict student performance based on various attributes.
- **Effectiveness of Educational Support**: Evaluate the impact of school and family support on student grades.
- **Impact of Absenteeism**: Analyze the long-term effects of absenteeism on academic performance.
- **Cultural Influences**: Explore how cultural factors affect education outcomes.

## Datasets
The datasets `student-mat.csv` and `student-por.csv` include information on student demographics, academic records, family background, and social behavior. Attributes cover details such as parental education, weekly study time, and health status, among others.

## Methodology
The project utilizes a mix of statistical tests, exploratory data analysis, and machine learning models including:
- Correlation and regression analysis
- t-tests, ANOVA, and chi-squared tests
- Decision trees and random forests
- Time series and longitudinal data analysis
- Factor analysis

## Tools and Technologies
- **Python**: For data manipulation (Pandas), data visualization (Matplotlib, Seaborn), statistical analysis (SciPy, statsmodels), and machine learning (scikit-learn).
- **R**: For advanced statistical modeling and factor analysis.
- **Jupyter Notebook**: For interactive data analysis and visualization.

## Directory Structure
```plaintext
.
├── data/
│ ├── student-mat.csv
│ ├── student-por.csv
│ └── metadata.txt
├── src/
│ ├── data_preprocessing.py
│ ├── exploratory_analysis.py
│ └── predictive_modeling.py
├── tests/
│ └── test_models.py
├── analyses/
│ └── statistical_tests.ipynb
├── outputs/
│ ├── figures/
│ └── tables/
├── reports/
│ └── final_report.md
└── makefile
```


## data/
This directory contains all raw and derived datasets used in the project. The `metadata.txt` file provides additional context and information about data sources, structure, and preprocessing steps.

## src/
The `src` folder includes all source code for data processing, analysis, and modeling. Scripts are modular and well-documented for easy replication and extension.

## tests/
All tests for the codebase reside here, ensuring that our data processing and analysis pipelines are robust and error-free.

## analyses/
Jupyter notebooks used for exploratory data analysis and statistical testing can be found here, detailing each step taken in the analysis process.

## outputs/
Generated figures and tables from our analyses are stored here for quick reference and use in reports or presentations.

## reports/
This folder contains our compiled reports, including a detailed final report that summarizes our methodology, findings, and implications of the study.

## makefile
The makefile contains commands for running tests, generating reports, and automating common development tasks to ensure a smooth workflow.

## Setup and Installation
To set up the project environment and install dependencies, follow these instructions:
(Include any relevant setup instructions here)

## Usage
For instructions on how to execute the code and reproduce the analyses, refer to the following:
(Include any relevant usage instructions here)

## Contributing
Contributions to the project are welcome. Guidelines for contributing can be found in the `CONTRIBUTING.md` file.

## License
This project is licensed under the MIT License - see the `LICENSE.md` file for details.

