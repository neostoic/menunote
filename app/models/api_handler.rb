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

  def self.yelp_request_data(path)
	cacheKey = 'yelp_' + path
	Rails.cache.fetch(cacheKey, :expires => 24.hour) do
		access_token = get_yelp_access_token()
		result = access_token.get(path).body
		JSON.parse(result)
	end
	result = Rails.cache.fetch(cacheKey)
	return result
  end

  def self.get_yelp_access_token
	cacheKey = 'yelp_access_token'
	Rails.cache.fetch(cacheKey, :expires => 24.hour) do
		require 'oauth'	
		consumer_key= ENV['yelp_consumer_key']
		consumer_secret= ENV['yelp_consumer_secret']
		token= ENV['yelp_token']
		token_secret= ENV['yelp_token_secret']
		api_host = 'api.yelp.com'
		consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
		access_token = OAuth::AccessToken.new(consumer, token, token_secret)
	end
	access_token = Rails.cache.fetch(cacheKey)
	return access_token
  end
  def self.twitter_search(query)
	cacheKey = 'tweet_' + query
	Rails.cache.fetch(cacheKey, :expires => 24.hour) do
		accessToken = get_twitter_access_token()
		requestAuth = "Bearer " + accessToken
		queryUrl = "https://api.twitter.com/1.1/search/tweets.json?q=#{URI.escape(query)}"
		searchResult = HTTParty.get(queryUrl, :headers => {
			"Authorization" => requestAuth
		})
		searchResult['statuses']
	end
	result = Rails.cache.fetch(cacheKey)
	return result
  end
  def self.get_twitter_access_token
	cacheKey = 'twitter_access_token'
	Rails.cache.fetch(cacheKey, :expires => 24.hour) do
		key = ENV['twitter_key']
		key = CGI.escape(key)
		secret = ENV['twitter_secret']
		secret = CGI.escape(secret)
		encodedKeySecret = Base64.strict_encode64("#{key}:#{secret}")
		headers = {
			'Authorization' => "Basic #{encodedKeySecret}",
			'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
		}
		result = HTTParty.post("https://api.twitter.com/oauth2/token",
			:body => 'grant_type=client_credentials',
			:headers => headers
		)
		result['access_token']
	end
	result = Rails.cache.fetch(cacheKey)
	return result
  end
end
