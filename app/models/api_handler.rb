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
   def self.get_matching_singleplatform_id(foursquare_id)
	path = '/location-match'
	data = {
		:matching_criteria => 'FOURSQUARE_ID',
		:locations => [{
			:foursquare_id => foursquare_id
		}]
	}
	response = APIHandler.singleplatform_matching(path, data)
	if response.nil?
		return nil
	end
	response = response['response']
	if response.nil? || response.length <= 0
		return nil
	end
	sp_id = response[0]['spv2id']
	if sp_id === false
		return nil
	end
	return sp_id
   end
   def self.singleplatform_matching(path, data)
	clientId = ENV['singleplatform_client_id']
	signingKey = ENV['singleplatform_signing_key']
	signatureBase = "#{path}?client=#{clientId}"
	signature = hmac_sha1(signatureBase, signingKey)
	searchUrl = "http://matching-api.singleplatform.com#{signatureBase}&signature=#{signature}"
	unless data.nil?
		data = data.to_json
	end
	response = HTTParty.post(searchUrl, :body => data)
	return response	

   end
   def self.singleplatform_publishing(path, data)
	clientId = ENV['singleplatform_client_id']
	signingKey = ENV['singleplatform_signing_key']
	signatureBase = "#{path}?client=#{clientId}"
	signature = hmac_sha1(signatureBase, signingKey)
	searchUrl = "http://publishing-api.singleplatform.com#{signatureBase}&signature=#{signature}"
	if data.nil?
		data = {}
	end
	response = HTTParty.get(searchUrl, data)
	return response	
  end
  def self.hmac_sha1(signatureBase, secretKey)
	require 'digest/hmac'
	digest = OpenSSL::Digest::Digest.new('sha1')
	hmac = OpenSSL::HMAC.digest('sha1', secretKey, signatureBase)
	hmacEncoded = CGI.escape(Base64.encode64(hmac).strip())
	return hmacEncoded
  end
end
