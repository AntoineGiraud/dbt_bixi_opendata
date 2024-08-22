with od as (
	select
		date_trunc('minute', to_timestamp(STARTTIMEMS/1000)::TIMESTAMPTZ AT TIME ZONE 'America/Montreal')::datetime as start_date,
		year(start_date) start_year,
		STARTSTATIONNAME,
		date_trunc('minute', to_timestamp(endTIMEMS/1000)::TIMESTAMPTZ AT TIME ZONE 'America/Montreal')::datetime as end_date,
		ENDSTATIONNAME,
		round((ENDTIMEMS - STARTTIMEMS)/1000, 0) as duration_sec,
	from {{ ref("raw_rentals_v2") }} od
)
select
	start_year,
	start_date,
	sta_start.rg_station_yearly as start_station_code,
	end_date,
	sta_end.rg_station_yearly as end_station_code,
	duration_sec,
	null::int as is_member,
from od
  left join {{ ref('stg_stations_v2') }} sta_start
    on sta_start.year = od.start_year and sta_start.station_name = od.STARTSTATIONNAME
  left join {{ ref('stg_stations_v2') }} sta_end
    on sta_end.year = od.start_year and sta_end.station_name = od.ENDSTATIONNAME