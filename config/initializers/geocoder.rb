Geocoder.configure(
  # Use OpenCage Geocoder for reliable geocoding
  # Falls back to Nominatim if needed
  lookup: :nominatim,
  
  # Timeout for geocoding requests (in seconds)
  timeout: 15,
  
  # Units for distance calculations
  units: :km,
  
  # User agent required by Nominatim
  user_agent: 'olx_marketplace_app',
  
  # Retry on failure
  always_raise: :all
)



