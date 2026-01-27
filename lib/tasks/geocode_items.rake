namespace :items do
  desc "Geocode all items with addresses but missing coordinates"
  task geocode_addresses: :environment do
    items_to_geocode = Item.where("address IS NOT NULL AND address != ''").where("latitude IS NULL OR longitude IS NULL")
    
    puts "Found #{items_to_geocode.count} items to geocode"
    
    items_to_geocode.find_each do |item|
      puts "Geocoding: #{item.title} - #{item.address}"
      item.send(:geocode_address)
      if item.save
        puts "  ✓ Success: #{item.latitude}, #{item.longitude}"
      else
        puts "  ✗ Failed: #{item.errors.full_messages.join(', ')}"
      end
    end
    
    puts "Done! #{Item.where("latitude IS NOT NULL AND longitude IS NOT NULL").count} items now have coordinates"
  end

  desc "Set default coordinates for all items without addresses"
  task set_default_locations: :environment do
    # Default location: New York City
    default_lat = 40.7128
    default_lng = -74.0060
    
    items_without_location = Item.where("address IS NULL OR address = ''")
    count = items_without_location.update_all(
      address: "New York, NY",
      latitude: default_lat,
      longitude: default_lng
    )
    
    puts "Updated #{count} items with default New York location"
  end
end
