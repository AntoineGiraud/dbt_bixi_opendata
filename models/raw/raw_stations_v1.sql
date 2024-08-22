
SELECT
	left(right(filename, 8), 4)::int as year,
	concat(year, '_', code) AS station_year_code,
	code,
	name,
	ST_point(round(longitude, 7), round(latitude, 7)) as station_geom,
	ST_X(station_geom) station_lng,
	ST_Y(station_geom) station_lat,
from {{ source('rentals', 'stations_v1') }}
    {# -- read_csv( 	'C:\Users\antoi\Documents\data\bixi\data_od_bixi_csv_v1\'
    --    || '**\Stations_*.csv',
    --    header=true, AUTO_DETECT=TRUE, filename=true) #}
order by 1,2,3