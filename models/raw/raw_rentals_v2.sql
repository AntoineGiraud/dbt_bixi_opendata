

select *
from {{ source('rentals', 'rentals_v2') }}
{# -- read_csv('C:\Users\antoi\Documents\data\bixi\data_od_bixi_csv_v2\DonneesOuverte20*.csv',
--    header=true, AUTO_DETECT=TRUE, filename=true) #}