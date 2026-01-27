namespace :geocoding do
  desc "Test if geocoding is working"
  task test: :environment do
    test_address = "30 Memorial Drive, Avon MA 2322"
    puts "Testing geocoding for: #{test_address}"
    
    begin
      results = Geocoder.search(test_address)
      puts "Results count: #{results.count}"
      
      if results.any?
        result = results.first
        puts "Geocoding successful!"
        puts "  Latitude: #{result.latitude}"
        puts "  Longitude: #{result.longitude}"
        puts "  Full address: #{result.address}"
      else
        puts "No results found for address"
      end
    rescue StandardError => e
      puts "Error during geocoding: #{e.message}"
      puts e.backtrace
    end
  end
end
