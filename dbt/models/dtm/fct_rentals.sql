with
    union_v1_v2 as (
        select * exclude (filename),
        from {{ ref("raw_rentals_v1") }}
        union all
        select * exclude (start_year),
        from {{ ref("stg_rentals_v2tov1") }}
    )

select
    date_trunc('month', start_date::date) as start_date_month,
    start_date::date as start_date,
    hour(start_date) as start_hour,
    end_date::date as end_date,
    hour(end_date) as end_hour,
    time_bucket(interval '15 minutes', start_date)::time as start_time_15min,
    least(round(duration_sec / 60 / 5, 0) * 5, 45) as duration_5min_group,
    round(duration_sec / 60, 0) as duration_min,
    concat(year(start_date), '_', start_station_code) as start_station_year_code,
    concat(year(start_date), '_', end_station_code) as end_station_year_code,
    is_member,
from union_v1_v2
