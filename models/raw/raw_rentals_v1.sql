

SELECT
    * replace( -- 👇 truncate datetime to minutes & cast
        concat(left(start_date::string, 16),':00')::datetime as start_date,
        concat(left(end_date::string, 16),':00')::datetime as end_date
    )
from {{ source('rentals', 'rentals_v1') }}
    {# --read_csv( 'C:\Users\antoi\Documents\data\bixi\data_od_bixi_csv_v1\'
    --   || '**\OD_20*.csv',
    --   header=true, AUTO_DETECT=TRUE, ignore_errors=true) #}
