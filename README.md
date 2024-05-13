# Student Performance Analysis Project
### Data Science Coursework 2 CID:01862429

## Overview
Welcome to the Student Performance Analysis Project repository! This project is an academic endeavor dedicated to modeling complex datasets to provide in-depth analytical reports. Our primary aim is to uncover insights from the "Student Attitude and Behavior" dataset, which is available for download from Kaggle at [this link](https://www.kaggle.com/datasets/susanta21/student-attitude-and-behavior). By analyzing this data, we seek to better understand the factors influencing student performance and well-being, with a focus on how their attitudes and behaviors impact their academic outcomes.

### Objectives
- To conduct a comprehensive analysis of the "Student Attitude and Behavior" dataset.
- To identify key factors that influence student academic performance and well-being.
- To develop predictive models that can forecast student success based on various behavioral and demographic indicators.
- To provide actionable insights that can help educators and policymakers in crafting effective interventions.

## Repository Structure
The repository is meticulously organized into several directories, each serving a distinct role in the project workflow:

```plaintext
.
├── data/
│ ├── raw_data/
│ ├── derived_data/
├── src/
├── test/
├── analysis/
├── figures/
├── reports/
```
### `data/`
This directory is home to all datasets used in the project:

- `raw_data/`: Contains the original, unmodified datasets downloaded from external sources.
- `derived_data/`: Houses modified datasets that have been cleaned and transformed for analysis.

### `src/`
Contains all R scripts and helper functions. Each script is thoroughly commented and documented using the Roxygen2 package to enhance readability and maintainability.

### `test/`
Includes unit tests for all functions in the src/ directory to ensure their reliability and accuracy. We utilize the testthat package for our testing framework.

### `analysis/`
Stores R scripts detailing exploratory data analyses, statistical testing, and model development. Each script is designed to be self-contained, using the here package to manage paths and dependencies seamlessly.

### `figures/`
All visual outputs from our scripts are saved here. This directory contains graphs, charts, and other graphical representations that summarize our findings and insights.

### `reports/`
This directory features detailed project reports which include methodology, results, and discussions on the findings. These reports are intended for sharing with stakeholders and the academic community.


## How to Use
To use this repository:

- Clone the repository to your local machine.
- Ensure that you have R and the necessary packages installed.
- Run the scripts in the src/ directory to set up the environment.
- Execute analysis scripts from the analyses/ directory to reproduce findings or to conduct new analyses.
- Contributing

We welcome contributions from the community, be it in the form of bug fixes, enhancements, or documentation improvements. Please send us a pull request or open an issue to discuss potential changes.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
