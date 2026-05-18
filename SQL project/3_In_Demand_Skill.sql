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
job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
-- Limit top 5 skill
LIMIT
    5;