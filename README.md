## Social Media and Mental Health - SQL Analysis

This project analyzes a dataset collected from a survey on the impact of social media usage on mental health. Using SQL, we explore correlations between social media habits and symptoms of ADHD, anxiety, depression, and self-esteem issues.

## 📊 Dataset Overview

The dataset was gathered from 481 survey participants at the University of Liberal Arts Bangladesh. It includes:
- Demographics: age, gender, relationship status, occupation
- Social media usage: platforms used, average daily time online
- Likert-scale responses to questions linked with mental health indicators

> **Note**: The sample size is limited and does not represent the general population.

## 🧹 Data Cleaning Steps

- Simplified and renamed long column headers
- Standardized gender values
- Converted age to integer
- Split multi-select platform column into boolean flags
- Created a cleaned `survey` CTE for analysis

## 🔍 Key Questions Explored

1. **Which social media platforms are most commonly used?**
2. **Does time spent on social media correlate with symptoms of ADHD, anxiety, depression, or low self-esteem?**
3. **Is there a correlation between age and time spent online?**
4. **What is the most common time online by relationship status?**

## 🧠 Mental Health Mapping

Survey responses were grouped into mental health categories:

- **ADHD**: purposeless scrolling, distraction, difficulty concentrating  
- **Anxiety**: restlessness, worry  
- **Depression**: depressive feelings, loss of interest, sleep issues  
- **Low Self-Esteem**: social comparison, validation-seeking  

## 🧾 SQL Techniques Used

- Common Table Expressions (CTEs)
- Data transformation using CASE, CAST, and IF
- Aggregations (AVG, COUNTIF)
- Correlation analysis using `CORR()`
- Ranking with `ROW_NUMBER()` and window functions

## ✅ Insights

- **YouTube (85.65%)** and **Facebook (84.62%)** are the most used platforms.
- More time online correlates with higher average mental health symptom scores.
- Weak negative correlation between age and time online (r = -0.361).
- Single and in-relationship groups spend more time online than divorced individuals.


