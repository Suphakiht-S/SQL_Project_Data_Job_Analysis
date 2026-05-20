# **Introduction**
Here is my first project on data job market analysis that dive down on to analysis of data analyst role to explore ;

- **💰 Top-paying job**
- **🔥 In-demand skills**
- **📈 Optimal skill** (High demand meets high salary)

Please feel free to explore my analysis of data analyst roles, along with the SQL queries used in this project. Without further ado, let's dive in.

> Check the SQL Queries : [SQL project folder]()
# **Background**
This project is driven by the desire to gain the overall picture of data analyst role as I am transitioning into the data job. My goal is to identify top-paid and in-demand skills through data-driven analysis.

>The dataset in this project is from [SQL Course](https://lukebarousse.com/sql) from 2023

## **The questions I wanted to answer through my SQL queries were :**
- What are the top-paying data analyst jobs?
- What skills are required for these top-paying jobs?
- What skills are most in demand for data analysts?
- Which skills are associated with higher salaries?
- What are the most optimal skills to learn?

# **Tools I Used**
In order to go through analysis of data analyst role. I am equiped with powerful sever key tools:
- **SQL** : The backbone of my analysis, allowing me to query the database and discover critical insights.
- **PostgreSQL** : The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code** : My go-to for database management and executing SQL queries.
- **Git & GitHub** : Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# **The Analysis**
All the query in this project aimed at investigating specific aspects of the data analyst job market. Below section is how I approached each question :

## **1. Top Paying Data Analyst Jobs**
In order to identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.


```sql
--Top 10 highest paying data analyst roles
SELECT
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
	name AS company_name
FROM
	job_postings_fact
-- Join skills_job table to get the skill name of the most paying job
LEFT JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
	job_title_short = 'Data Analyst' AND
	job_location = 'Anywhere' AND
	salary_year_avg IS NOT NULL
ORDER BY
	salary_year_avg DESC 
LIMIT 10
```
Below is the breakdown of the top data analyst jobs in 2023 :
- **Wide Salary Range** : Top 10 paying data analyst roles span from $184,000 to $650,000, indicating potential of high salary  in the field.
- **Diverse Employers** : Companies like Noblis, Meta, and AT&T are among those offering high salaries, showing a variety of interest across different industries.

![alt text](<New folder/1_Top_paying_job.png>)
*Bar graph visualizing the salary for the top 10 company that potentially has high salaries for data analysts.*

## **2. Skills for Top Paying Jobs***
In order to know the required skills for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value the most for high-compensation roles.
```sql
-- CTE : The top 10 paying Data Analyst jobs list (From the first query)
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON
        job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

-- Required Skills for data analyst jobs
SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
-- Join skills_job_dim table to get the skill of the most paying job
INNER JOIN
    skills_job_dim ON
        top_paying_jobs.job_id = skills_job_dim.job_id
-- Join skills_job  table to get the skill name of the most paying job
INNER JOIN
    skills_dim ON
        skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```
Below is the breakdown of the most demanded or required skills for the top 10 highest paying data analyst jobs in 2023 :
- **SQL** is the lead with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6.
- Other skills like **R**, **Snowflake**, **Pandas** **Excel** , etc. show varying degrees of demand.

![alt text](<New folder/2_The_demanded_skill.png>)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts.*

## **3. In-Demand Skills for Data Analysts**

This query identify the skills that is most frequently requested in job postings, directing focus to areas with high demand.

```sql
-- The top 5 most demanded skills for Data Analyst job postings
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
-- Join skills_job_dim to get the skill of the most paying job
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
-- Join skills_job to get the skill name of the most paying job
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
-- Filters job titles for 'Data Analyst' roles
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere'
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
-- Limit top 5 skill
LIMIT
    5;
```
Below is the breakdown of the most demanded skills for data analysts in 2023
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.
<center>

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |
</center>

*Table of the demand for the top 5 skills in data analyst job postings*

![alt text](<New folder/3_In-demand skill for Data analyst.png>)
*Bar graph visualizing the salary for the demand for top 5 skills in data analysts job posting.*
## **4. Skills Based on Salary**
This query explores the average salaries relative to each skill revealed which skills are the highest paying.
```sql
-- The average salary for job postings by individual skill 
SELECT
    skills_dim.skills AS skill, 
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
FROM
    job_postings_fact
-- Join skills_job_dim to get the skill of the most paying job
INNER JOIN
	skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
-- Join skills_job to get the skill name of the most paying job
INNER JOIN
	skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_postings_fact.job_location = 'Anywhere'
GROUP BY
    skills_dim.skills 
ORDER BY
    avg_salary DESC; 
```
Below is the breakdown of the results for top paying skills for Data Analysts:
- **High Demand for Big Data & ML Skills** : Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency** : Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise** : Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.
<center>

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |
</center>

*Table of the average salary for the top 10 paying skills for data analysts*

## 5. **Most Optimal Skills to Learn**

This query combines insights from demand and salary data, aiming to identify the skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
-- CTE : Skills in high demand for Data Analyst roles
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
		    skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
-- Join skills_job to get the skill name of the most paying job
    INNER JOIN
	      skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
-- Join skills_job to get the skill name of the most paying job
    INNER JOIN
	    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.salary_year_avg IS NOT NULL AND
        job_postings_fact.job_location = 'Anywhere'
    GROUP BY
        skills_dim.skill_id
),

-- CTE : Skills with high average salaries for Data Analyst roles
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        AVG(job_postings_fact.salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
	INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.salary_year_avg IS NOT NULL AND
        job_postings_fact.job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

-- Return high demand and high salaries for 10 skills 
SELECT
    skills_demand.skills,
    skills_demand.demand_count,
    ROUND(average_salary.avg_salary, 2) AS avg_salary --ROUND function is used to round to 2 decimals 
FROM
    skills_demand
INNER JOIN
	average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_count DESC, 
	avg_salary DESC
LIMIT
    25 ; 
```
<center>

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 8        | go         | 27           |            115,320 |
| 234      | confluence | 11           |            114,210 |
| 97       | hadoop     | 22           |            113,193 |
| 80       | snowflake  | 37           |            112,948 |
| 74       | azure      | 34           |            111,225 |
| 77       | bigquery   | 13           |            109,654 |
| 76       | aws        | 32           |            108,317 |
| 4        | java       | 17           |            106,906 |
| 194      | ssis       | 12           |            106,683 |
| 233      | jira       | 20           |            104,918 |

</center>

*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023 : 
- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

# **What I Learned**
Throughout this adventure, I gained so much knowledge on SQL toolkit with evidence of data analyst job posting analysis:

- **🧠 Complex Query Development** : Strengthened advanced SQL skills by crafting complex queries, efficiently joining multiple tables, and utilizing CTEs (WITH clauses) to create structured and reusable temporary result sets.**
- **ℹ️ Data Aggregation** : Developed strong data summarization skills using GROUP BY alongside aggregate functions such as COUNT() and AVG() to extract meaningful insights from datasets.
- **🪄 Analytical Problem-Solving** : Enhanced real-world analytical thinking by translating business questions into actionable and insight-driven SQL queries.

# **Conclusions**
## Insights
From the analysis, several general insights emerged :

1. **Top-Paying Data Analyst Roles**: Remote data analyst positions offer highly competitive salaries, with top-paying roles reaching up to $650,000 annually.
2. **Key Skills for High-Paying Jobs**: Advanced SQL proficiency consistently appears as a core requirement for top-paying data analyst positions, highlighting its importance in maximizing earning potential.
3. **Most In-Demand Skills**: SQL remains the most sought-after skill in the data analyst job market, making it an essential competency for aspiring analysts.
4. **Skills Associated with Higher Salaries**: Specialized technical skills such as SVN and Solidity are linked to some of the highest average salaries, demonstrating the market value of niche expertise.
5. **Optimal Skills for Career Growth** : SQL stands out as one of the most valuable skills for data analysts due to its strong combination of high demand and competitive salary potential.

## Final take away
1. SQL remains one of the most valuable skills in data analytics due to its strong combination of high demand and competitive salary potential.
2. Cloud platforms such as Snowflake, AWS, and Azure provide strong career ROI, as they are associated with higher-paying analyst roles and growing industry demand.
3. Data visualization tools like Tableau and Power BI, along with Python, have become essential skills for modern data analysts seeking to deliver actionable insights effectively.
4. Understanding which skills command higher salaries helps prioritize learning paths and align career development with market demand and long-term growth opportunities.

## Closing Thoughts
- This project strengthened my SQL skills while providing valuable insights into the data analyst job market. The analysis highlights the importance of developing high-demand, high-value skills to stay competitive and adapt to industry trends.