{{
    config(
        materialized="external", options={"partition_by": "year", "overwrite": True}
    )
}}

with
    od as (
        select
            date_trunc(
                'minute',
                to_timestamp(
                    starttimems / 1000
                )::timestamptz at time zone 'America/Montreal'
            )::datetime as start_date,
            year(start_date) as year,
            startstationname,
            date_trunc(
                'minute',
                to_timestamp(
                    endtimems / 1000
                )::timestamptz at time zone 'America/Montreal'
            )::datetime as end_date,
            endstationname,
            round((endtimems - starttimems) / 1000, 0) as duration_sec,
        from {{ ref("raw_rentals_v2") }}
    )

select
    od.year,
    start_date,
    sta_start.rg_station_yearly as start_station_code,
    end_date,
    sta_end.rg_station_yearly as end_station_code,
    duration_sec,
    null::int as is_member,
from od
left join
    {{ ref("stg_stations_v2") }} as sta_start
    on sta_start.year = od.year
    and sta_start.station_name = od.startstationname
left join
    {{ ref("stg_stations_v2") }} as sta_end
    on sta_end.year = od.year
    and sta_end.station_name = od.endstationname
order by od.year, od.start_date
