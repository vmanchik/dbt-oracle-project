-- First dbt model for Oracle
-- This model gets current date from Oracle

{{ config(materialized='table') }}

select 
    sysdate as current_date,
    user as current_user,
    sys_context('USERENV', 'DB_NAME') as db_name
from 
    dual
