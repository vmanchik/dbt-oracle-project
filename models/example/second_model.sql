-- Second dbt model for Oracle
-- This model references the first model

{{ config(materialized='view') }}

select 
    fm.current_date as current_date,
    fm.current_user as current_user,
    fm.db_name as db_name,
    'Model created at ' || to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') as model_timestamp
from 
    {{ ref('first_model') }} fm
