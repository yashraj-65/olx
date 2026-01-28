# config/initializers/geocoder.rb
Geocoder.configure(
  # Street address geocoding service
  lookup: :mapbox,

  # Use your existing Mapbox token from your .env or credentials
  api_key: ENV['MAPBOX_ACCESS_TOKEN'],

  # Use HTTPS
  use_https: true,

  # Standard timeout
  timeout: 5,

  # Units to use for distance
  units: :km
)