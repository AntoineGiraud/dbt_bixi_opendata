with
    t as (
        select unnest(features) as feat,
        from {{ source("sectors", "municipal_sectors_od_survey_2013") }}
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
