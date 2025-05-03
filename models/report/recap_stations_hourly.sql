
with starts as (
	select
		start_date as date,
		start_station_year_code as station_year_code,
		start_hour as heure,
		count(1) nb_rentals_starts,
		count(1) filter (is_member=0) nb_rentals_casual_starts,
		sum(duration_min) sum_duration_starts,
		count(if(duration_min<15, 1, null)) nb_rentals_0_14min_starts,
		count(if(duration_min between 15 and 29, 1, null)) nb_rentals_15_29min_starts,
		count(if(duration_min between 30 and 44, 1, null)) nb_rentals_30_44min_starts,
		count(if(duration_min>=45, 1, null)) nb_rentals_45min_starts,
	from {{ ref('fct_rentals') }}
	group by all
), ends as (
	select
		end_date as date,
		end_station_year_code as station_year_code,
		end_hour as heure,
		count(1) nb_rentals_ends,
		count(1) filter (is_member=0) nb_rentals_casual_ends,
		sum(duration_min) sum_duration_ends,
		count(if(duration_min<15, 1, null)) nb_rentals_0_14min_ends,
		count(if(duration_min between 15 and 29, 1, null)) nb_rentals_15_29min_ends,
		count(if(duration_min between 30 and 44, 1, null)) nb_rentals_30_44min_ends,
		count(if(duration_min>=45, 1, null)) nb_rentals_45min_ends,
	from {{ ref('fct_rentals') }}
	group by all
)
select
	coalesce(starts.date, ends.date) as date,
	coalesce(starts.station_year_code, ends.station_year_code) as station_year_code,
	coalesce(starts.heure, ends.heure) as heure,
	starts.nb_rentals_starts,
	ends.nb_rentals_ends,
	starts.nb_rentals_casual_starts,
	ends.nb_rentals_casual_ends,
	starts.sum_duration_starts,
	ends.sum_duration_ends,
	starts.nb_rentals_0_14min_starts,
	ends.nb_rentals_0_14min_ends,
from starts
 full outer join ends using(date, station_year_code, heure)
order by 1, 2, 3
