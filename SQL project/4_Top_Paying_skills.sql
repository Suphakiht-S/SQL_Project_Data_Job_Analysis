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