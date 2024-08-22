{{ config(materialized='view') }}

select *
from {{ ref('raw_sectors') }}