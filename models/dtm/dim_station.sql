

with union_stations as (
	select * from {{ ref('raw_stations_v1') }}
	 union all
	select year, station_year_code, rg_station_yearly as code, station_name as name, station_geom, station_lng, station_lat
 	from {{ ref('stg_stations_v2') }}
)
select sta.*, arr.*
from union_stations sta
  left join {{ ref('raw_sectors') }} arr on ST_Within(station_geom, sector_geom)