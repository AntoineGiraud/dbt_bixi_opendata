select
    left(right(filename, 8), 4)::int as year,
    concat(year, '_', code) as station_year_code,
    code::int as code,
    name,
    st_point(round(longitude::float, 7), round(latitude::float, 7)) as station_geom,
    st_x(station_geom) as station_lng,
    st_y(station_geom) as station_lat,
from {{ source('rentals', 'stations_v1') }}
-- where TRY_CAST(code as integer) is not null -- station test
order by 1, 2, 3
