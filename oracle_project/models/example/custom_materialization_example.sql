/*
    Using custom materialization with indexes
*/

{{ config(
    materialized='table_with_indexes',
    indexes=[
        {
            'name': 'idx_custom_id',
            'columns': ['id'],
            'unique': false
        },
        {
            'name': 'idx_custom_code',
            'columns': ['code'],
            'unique': true
        }
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
