/*
    Example model showing different ways to create indexes in dbt
*/

{{ config(
    materialized='table',
    post_hook=[
      "create index idx_{{ this.name }}_id on {{ this }} (id)",
      "create index idx_{{ this.name }}_name on {{ this }} (name)",
      "create unique index idx_{{ this.name }}_unique_code on {{ this }} (code)"
    ]
) }}

-- Sample data with columns to index
with source_data as (
    select 1 as id, 'First Item' as name, 'CODE1' as code from dual
    union all
    select 2 as id, 'Second Item' as name, 'CODE2' as code from dual
    union all
    select 3 as id, 'Third Item' as name, 'CODE3' as code from dual
)

select *
from source_data
