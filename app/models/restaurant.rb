class Restaurant < ActiveRecord::Base
   has_one :menu
   has_many :cuisine_types
   has_many :hours
   has_many :payment_types
   has_many :served_meals
   def self.search_by_name(query, location)
	query = CGI.escape(query)
	location = CGI.escape(query)
	path = "/v2/venues/search?query=#{query}&near=#{location}"
	# for latitude and longitude, replace near with ll=#{lat},#{long}
	data = {
		:v => Time.now,
		:limit => 50
	}
	searchResult = APIHandler.foursquare_request_data(path, data)
	if searchResult.nil? || searchResult['venues'].nil?
		return nil
	end
	restaurantsArray = Array.new
	searchResult = searchResult['venues']
	searchResult.each_with_index do |venue|
		fsId = venue['id']
		restaurantObj = Restaurant.find_by_foursquare_id(fsId)
		if restaurantObj.nil?
			restaurantObj = Restaurant.create_foursquare_venue(venue)
		end
		restaurantsArray << restaurantObj	
	end
	return restaurantsArray
   end

   def self.create_foursquare_venue(venue)
	restaurantObj = Restaurant.new(
		:foursquare_id => venue['id'],
		:name => venue['name'],
	)
	venueLocation = venue['location']
	unless venueLocation.nil?
		restaurantObj['address1'] = venueLocation['address']
		restaurantObj['city'] = venueLocation['city']
		restaurantObj['state'] = venueLocation['state']
		restaurantObj['country'] = venueLocation['country']
		restaurantObj['postal_code'] = venueLocation['postalCode']
		restaurantObj['latitude'] = venueLocation['lat']
		restaurantObj['longitude'] = venueLocation['lng']
	end
	venueContact = venue['contact']
	unless venueContact.nil?
		restaurantObj['phone'] = venueContact['phone']
	end
	restaurantObj.save
	return restaurantObj
   end
end
