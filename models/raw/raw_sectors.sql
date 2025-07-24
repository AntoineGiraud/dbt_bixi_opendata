with t as (
    select unnest(features) as feat,
    from {{ source('sectors', 'municipal_sectors_od_survey_2013') }}
    {# from read_json_auto('C:\Users\antoi\Documents\codes\bikeshare_project\communes_geom\artm-sm-od13.geojson', sample_size=-1) #}
    {# from read_json_auto('https://www.donneesquebec.ca/recherche/dataset/b57cdeb1-98e7-4db7-bb84-32530f0367eb/resource/95ab084b-727e-4322-9433-0fed7baa690d/download/artm-sm-od13.geojson', sample_size=-1) #}
)

select
    feat.properties.sm13::int as sector_id,
    feat.properties.sm13_nom as sector_name,
    feat.properties.ra::int as sector_ra,
    st_geomfromgeojson(feat.geometry::json) as sector_geom,
    st_centroid(sector_geom) as sector_centroid,
    st_x(sector_centroid) as sector_centroid_lng,
    st_y(sector_centroid) as sector_centroid_lat,
    -- feat.properties sector_props,
from t
