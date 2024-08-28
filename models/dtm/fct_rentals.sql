with union_v1_v2 as (
    select * exclude(filename) from {{ ref("raw_rentals_v1") }}
    union all
    select * exclude(start_year) from {{ ref("stg_rentals_v2tov1") }}
)
SELECT
    date_trunc('month', start_date::date) start_date_month,
    start_date::date start_date,
    hour(start_date) AS start_hour,
    time_bucket(interval '15 minutes', start_date)::time AS start_time_15min,
    least(round(duration_sec / 60 /5, 0)*5, 45) duration_5min_group,
    round(duration_sec / 60, 0) duration_min,
    concat(YEAR(start_date), '_', start_station_code) start_station_year_code,
    concat(YEAR(start_date), '_', end_station_code) end_station_year_code,
    is_member
from union_v1_v2
