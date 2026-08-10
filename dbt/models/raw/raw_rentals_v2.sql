{{ config(materialized="view") }}

from {{ source("rentals", "rentals_v2") }}
