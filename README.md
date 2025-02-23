Project Summary: Machine Failure Analysis & Prediction Introduction Machine failures in industrial settings can lead to significant production losses, increased maintenance costs, and unexpected downtime. This project focuses on analyzing machine failure data to identify key factors contributing to failures and suggest data-driven solutions to improve machine reliability.

bjective The primary goal of this project is to perform Exploratory Data Analysis (EDA) on machine failure data to uncover insights and provide recommendations for predictive maintenance.

Steps Followed in the Project

Data Cleaning & Preprocessing
Removed duplicates & missing values. Converted categorical variables to optimized data types. Standardized column names for better readability.

Exploratory Data Analysis (EDA)
Univariate Analysis: Studied feature distributions using histograms and boxplots. Bivariate Analysis: Explored relationships between variables using scatter plots and correlation heatmaps. Multivariate Analysis: Identified interactions between multiple machine parameters.

Key Insights from EDA
Failures are rare (~1.57%), making this a highly imbalanced dataset. Tool wear failure (TWF) is the most frequent cause of machine breakdowns. Machines with high rotational speed & extreme torque variations are more likely to fail. Process temperature increases with air temperature, which may impact failures. Certain machine types have a higher failure rate, suggesting design improvements are needed.

Business Impact & Recommendations
Implement a predictive maintenance system to detect failures before they occur. Optimize machine operating conditions by setting safe limits for speed, torque, and temperature. Focus on high-failure machine types for design improvements. Proactively replace tools before excessive wear leads to failures. Conclusion By leveraging EDA insights, companies can take preventive actions to reduce machine failures, improve operational efficiency, and lower maintenance costs. This project provides a strong foundation for future predictive modeling to classify machine failures and develop an early warning system.
