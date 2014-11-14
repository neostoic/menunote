class Restaurant < ActiveRecord::Base
   has_one :menu
   has_many :cuisine_types
   has_many :hours
   has_many :payment_types
   has_many :served_meals

   def self.search_by_name(query, location)
	query = CGI.escape(query)
	location = CGI.escape(location)
	path = "/v2/venues/search?query=#{query}&near=#{location}"
	# for latitude and longitude, replace near with ll=#{lat},#{long}
	data = {
		:v => Time.now,
		:limit => 10
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
	foursquareId = venue['id']
	sp_id = APIHandler.get_matching_singleplatform_id(foursquareId)
	restaurantObj = Restaurant.new(
		:foursquare_id => foursquareId,
		:name => venue['name'],
		:sp_id => sp_id
	)
	if sp_id.nil?
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
	else
		path = '/locations/' + sp_id + '/all'
		spLocation = APIHandler.singleplatform_publishing(path, nil)
		unless spLocation.nil? || spLocation['data'].nil? || spLocation['data']['location'].nil?
			spLocation = spLocation['data']['location']
			restaurantObj.business_type = spLocation['business_type']
			restaurantObj.website = spLocation['website']
			restaurantObj.is_owner_verified = spLocation['is_owner_verified']
			restaurantObj.description = spLocation['description']
			restaurantObj.time_zone = spLocation['time_zone']
			restaurantObj.email = spLocation['email']
			restaurantObj.phone = spLocation['phone']
			restaurantObj.published_at = spLocation['published_at']
			restaurantObj.out_of_business = spLocation['out_of_business']
		end
	end
	restaurantObj.save
	return restaurantObj
   end
   def load_menu
	sp_id = self.sp_id
	if sp_id.nil?
		return nil
	end
	self.menu = Menu.create_restaurant_menu(self)
	self.save	
	return 'hi'  
   end
end
