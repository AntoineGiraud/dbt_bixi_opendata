
with t as (
	select unnest(features) feat
    from {{ source('sectors', 'municipal_sectors_od_survey_2013') }}
	{# from read_json_auto('C:\Users\antoi\Documents\codes\bikeshare_project\communes_geom\artm-sm-od13.geojson', sample_size=-1) #}
	{# from read_json_auto('https://www.donneesquebec.ca/recherche/dataset/b57cdeb1-98e7-4db7-bb84-32530f0367eb/resource/95ab084b-727e-4322-9433-0fed7baa690d/download/artm-sm-od13.geojson', sample_size=-1) #}
)
select
    feat.properties.SM13::int sector_id,
    feat.properties.SM13_nom sector_name,
    feat.properties.RA::int sector_ra,
    ST_GeomFromGeoJSON(feat.geometry::json) sector_geom,
    ST_Centroid(sector_geom) sector_centroid,
    ST_X(sector_centroid) sector_centroid_lng,
    ST_Y(sector_centroid) sector_centroid_lat,
    -- feat.properties sector_props,
from t