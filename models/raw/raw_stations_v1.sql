
SELECT
	left(right(filename, 8), 4)::int as year,
	concat(year, '_', code) AS station_year_code,
	code::int as code,
	name,
	ST_point(round(longitude::float, 7), round(latitude::float, 7)) as station_geom,
	ST_X(station_geom) station_lng,
	ST_Y(station_geom) station_lat,
from {{ source('rentals', 'stations_v1') }}
-- where TRY_CAST(code as integer) is not null -- station test
order by 1,2,3