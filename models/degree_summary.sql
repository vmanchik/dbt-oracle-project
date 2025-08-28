/*
    Example model using kpi_degree_crosswalk seed data
*/

WITH crosswalk_data AS (
    SELECT * FROM {{ ref('kpi_degree_crosswalk') }}
)

SELECT
    KPI_DEGREE,
    KPI_DIVISION,
    COUNT(*) as program_count
FROM crosswalk_data
GROUP BY KPI_DEGREE, KPI_DIVISION
ORDER BY program_count DESC
