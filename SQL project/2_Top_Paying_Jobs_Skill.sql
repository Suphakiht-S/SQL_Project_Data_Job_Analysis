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