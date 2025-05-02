-- les fichiers de 2014 à 2020 respectent la mm norme :)
SELECT
    concat(left(start_date::string, 16),':00')::datetime as start_date, -- déjà tronqué à la minute
    start_station_code::int as start_station_code,
    concat(left(end_date::string, 16),':00')::datetime as end_date, -- mais on en sait jamais
    end_station_code::int as end_station_code,
    duration_sec::int as duration_sec,
    is_member::int as is_member,
    filename,
from {{ source('rentals', 'rentals_v1') }}
 {# --read_csv('~\Documents\codes\dbt_bixi_opendata\input/rentals_v1/*.csv', filename=true, all_varchar=1) #}
where TRY_CAST(start_station_code as integer) is not null -- station test

union all

-- le fichier de 2021 n'ayant pas respecté le standard 2020 et avant
SELECT
    concat(left(start_date::string, 16),':00')::datetime as start_date, -- grain au miliseconde ...
    emplacement_pk_start::int as start_station_code,
    concat(left(end_date::string, 16),':00')::datetime as end_date,
    emplacement_pk_end::int as end_station_code,
    duration_sec::int as duration_sec,
    is_member::int as is_member,
    filename,
from {{ source('rentals', 'rentals_v1_2021') }}
where TRY_CAST(emplacement_pk_start as integer) is not null
