class APIHandler < ActiveRecord::Base
   def self.foursquare_request_data(path, data)
	self.foursquare_init()
	return Fsquare.request_data(path, data)	
   end
   def self.foursquare_init
	clientId = ENV['foursquare_client_id']
	clientSecret = ENV['foursquare_client_secret']
	Fsquare.initialize(clientId, clientSecret)
   end
	
end
