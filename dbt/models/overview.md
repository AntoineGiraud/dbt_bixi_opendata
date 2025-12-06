{% docs __overview__ %}

# Bixi's OpenData Modelisation

## Data sources :

### Bixi Rentals OpenData ([link](https://bixi.com/fr/donnees-ouvertes/))

- 🚲 **Rentals V1** : from 2014 to 2021
- ⛽ **Stations V1** : from 2014 to 2021 (1 station per year)
- 🚲 **Rentals V2** : from 2022 to 2024+ (start/end station info on each rentals)

### Geospatial

- 🧭 **Municipal sectors** : from the OD 2013 survey (cf. [donnees quebec](https://www.donneesquebec.ca/recherche/dataset/artm-secteurs-municipaux-od13/resource/95ab084b-727e-4322-9433-0fed7baa690d))

## Schema/DB steps

- **raw** : raw tables loaded as is from .csv
- **stg** : intermediate tables
- **dtm** : tables ready for analytics & reporting use

{% enddocs %}
