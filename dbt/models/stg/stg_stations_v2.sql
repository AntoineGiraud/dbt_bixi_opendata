with station_tmp as (
    select
        year(to_timestamp(starttimems / 1000)::timestamptz at time zone 'America/Montreal') as year,
        startstationname as station_name,
        max(startstationarrondissement) as arrondissement,
        -- string_agg(distinct STARTSTATIONARRONDISSEMENT, ', ') as agg_arr,
        count(distinct concat(
            round(startstationlongitude, 6), '_', round(startstationlatitude, 6)
        )) as nb_coords,
        case
            when nb_coords > 1
            then st_makeline(array_agg(distinct
                    st_point(round(startstationlongitude, 6), round(startstationlatitude, 6))
                ))
            else st_makeline(
                    st_point(round(max(startstationlongitude), 6), round(max(startstationlatitude), 6)),
                    st_point(round(max(startstationlongitude), 6), round(max(startstationlatitude), 6))
                )
        end as agg_coords,
    from {{ ref("raw_rentals_v2") }}
    where startstationlongitude != 0 and startstationlatitude != 0
    group by 1, 2
)
select
    year,
    row_number() over (partition by year order by arrondissement, station_name) as rg_station_yearly,
    concat(year, '_', rg_station_yearly) as station_year_code,
    station_name,
    arrondissement,
    st_startpoint(agg_coords) as station_geom,  -- pour être sûr de sortir une coordonnée ayant existée
    st_x(station_geom) as station_lng,
    st_y(station_geom) as station_lat,
    nb_coords,
    agg_coords,
from station_tmp
order by 1, 2
