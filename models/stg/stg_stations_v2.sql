with station_tmp as (
	select
		year(to_timestamp(STARTTIMEMS/1000)::TIMESTAMPTZ AT TIME ZONE 'America/Montreal') as year,
		STARTSTATIONNAME as station_name,
		max(STARTSTATIONARRONDISSEMENT) as arrondissement,
		-- string_agg(distinct STARTSTATIONARRONDISSEMENT, ', ') as agg_arr,
		count(distinct concat(round(STARTSTATIONLONGITUDE, 6), '_', round(STARTSTATIONLATITUDE, 6))) as nb_coords,
		case when nb_coords > 1
		  	then ST_MakeLine(array_agg(distinct ST_point(round(STARTSTATIONLONGITUDE, 6), round(STARTSTATIONLATITUDE, 6))))
		  	else ST_MakeLine(
		  			ST_point(round(max(STARTSTATIONLONGITUDE), 6), round(max(STARTSTATIONLATITUDE), 6)),
		  			ST_point(round(max(STARTSTATIONLONGITUDE), 6), round(max(STARTSTATIONLATITUDE), 6))
		  		)
		  end as agg_coords
	from {{ ref('raw_rentals_v2') }}
	where STARTSTATIONLONGITUDE != 0 and STARTSTATIONLATITUDE != 0
	group by 1, 2
)
select
	year,
	row_number() over (partition by year order by arrondissement, station_name) as rg_station_yearly,
	concat(year, '_', rg_station_yearly) as station_year_code,
	station_name,
	arrondissement,
	ST_StartPoint(agg_coords) as station_geom, -- pour être sûr de sortir une coordonnée ayant existée
	ST_X(station_geom) as station_lng,
	ST_Y(station_geom) as station_lat,
	nb_coords,
	agg_coords,
from station_tmp
order by 1,2