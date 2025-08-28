/*
    Using the employees seed data
*/

WITH employee_data AS (
    SELECT * FROM {{ ref('employees') }}
)

SELECT
    id,
    firstname || ' ' || lastname as full_name,
    department,
    salary,
    TO_DATE(hiredate, 'YYYY-MM-DD') as hire_date
FROM employee_data
ORDER BY department, salary DESC
