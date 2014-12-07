class MenuItem < ActiveRecord::Base
   has_many :images
   has_many :menu_additions
   has_many :menu_choices
   has_one :restaurant
   def get_image_url
	unless self.photo_url.nil?
		return self.photo_url
	end
	imageUrl = 'http://www.hollandlift.com/wp-content/themes/hollandlift/assets/images/no_image.jpg'
	restaurant = self.get_restaurant()
	restaurantUrl = restaurant.get_website()
	menuItemName = self.name
=begin
	query = menuItemName + ' site:' + restaurantUrl
	# Google Search
	googleResults = APIHandler.google_custom_search(query)
	unless googleResults.nil? || googleResults.length <= 0
		googleResults.each do |result|
			resultImgTitle = result['snippet']

			if MenuItem.is_valid_image_title(menuItemName, resultImgTitle) === true
				return result['link']
			end
		end
	end
=end
	query = menuItemName + ' ' + restaurant.name + ' related:foodspotting.com'
	# Foodspotting
	googleResults = APIHandler.google_custom_search(query)
	unless googleResults.nil? || googleResults.length <= 0
		googleResults.each do |result|
			resultImgTitle = result['snippet']

			if MenuItem.is_valid_image_title(menuItemName, resultImgTitle) === true
				return result['link']
			end
		end
	end
=begin
	# Bing Search
	bingResults = APIHandler.bing_search("Image", query)['results']
	unless bingResults.nil? || bingResults.length <= 0
		bingResults.each do |result|
			resultImgTitle = result['Title']
			if MenuItem.is_valid_image_title(menuItemName, resultImgTitle) === true
				imageUrl = result['MediaUrl']
				return imageUrl
			end
		end
	end
	return imageUrl
=end
   end
   def self.is_valid_image_title(menuItemName, resultImgTitle)
	menuItem = menuItemName.downcase
	imageTitle = resultImgTitle.downcase
	if menuItem === imageTitle
		return true
	end
	if (menuItem.include? imageTitle) || (imageTitle.include? menuItem)
		return true
	end
	diffNumLetters = (menuItemName.length - resultImgTitle.length).abs
	if diffNumLetters > 20
		return false
	end
	regexpStr = menuItemName.gsub(/[^ A-Za-z&'*"]/, '').sub(/^ /,'').sub(/ $/,'')
	regexpStr = regexpStr.gsub(' ', '|')
	matchWords = resultImgTitle.scan(Regexp.new(regexpStr, 'gi'))
	unless matchWords.nil?
		numMatchingWords = matchWords.length
		numRegexpWords = regexpStr.split("|").length
		if numMatchingWords >= numRegexpWords.to_f/2	
			return true
		end
	end
	return false
   end
   def get_restaurant
	restaurantId = self.restaurant_id
	restaurant = Restaurant.find(restaurantId)
	return restaurant
   end
   def get_reviews
	foursquare_tips = get_foursquare_tips()
	#yelp_reviews = get_yelp_reviews()
	tweets = get_tweets()
	combinedReviews = foursquare_tips.concat(tweets)
	if combinedReviews.nil?
		combinedReviews = Array.new
	end
	return combinedReviews
   end
   def get_foursquare_tips()
	reviews = Array.new
	menuItemName = self.name.downcase
	restaurant = get_restaurant()
	path = "/v2/venues/#{restaurant.foursquare_id}/tips?"
	data = {
		:v => Time.now,
		:limit => 500
	}
	tips = APIHandler.foursquare_request_data(path, data)
	if tips.nil? || tips['tips'].nil? || tips['tips']['items'].nil?
		return reviews
	end
	tips = tips['tips']['items']
	unless tips.nil?
		tips.each do |tip|
			text = tip['text']
			if text.nil?
				continue
			end
			if text.downcase.include? menuItemName
				user = tip['user']
				userFirstName = user['firstName']
				userLastName = user['lastName']
				userFullName = Array.new
				unless userFirstName.nil?
					userFullName << userFirstName
				end
				unless userLastName.nil?
					userFullName << userLastName
				end
				review = {
					"user_name"=> userFullName.join(" "),
					"user_image_url"=> user['photo'],
					"text"=> text,
					"date_created"=> tip['createdAt'],
					"source"=>"Foursquare"
				}
				reviews << review
			end
		end
	end
	return reviews
   end
   def get_yelp_reviews
	restaurant = self.get_restaurant()
	path = "/v2/business/#{restaurant.yelp_id}"
	reviews = Array.new
	yelpReviews = APIHandler.yelp_request_data(path)
	if yelpReviews.nil?
		return reviews
	end
	yelpReviews = yelpReviews['reviews']
	if yelpReviews.nil?
		return reviews
	end
	yelpReviews.each do |yelpReview|
		review = {
			"user_name"=> yelpReview['user']['name'],
			"user_image_url"=> yelpReview['user']['image_url'],
			"text"=> yelpReview['excerpt'],
			"date_created"=> yelpReview['time_created'],
			"source"=>"Yelp"
		}
		reviews << review	
	end
	return reviews
   end
   def get_tweets
	restaurant = get_restaurant()
	query = restaurant.name + ' ' + self.name
	tweets = Array.new
	searchResults = APIHandler.twitter_search(query)
	searchResults.each do |result|
		text = result['text']
#		isRetweet = text.index("RT @") === 0
#		if isRetweet !== true
			tweet = {
				"user_name"=> result['user']['name'],
				"user_image_url"=> result['user']['profile_image_url'],
				"text"=> text,
				"date_created"=> result['created_at'].to_datetime.to_i,
				"source"=>"Twitter"
			}
			tweets << tweet
#		end
	end
	return tweets
   end
   def self.create_menu_item(spItem, sectionObj)
	menuItemObj = MenuItem.new(
		:sp_id => spItem['id'],
		:name => spItem['name'],
		:description => spItem['description'],
		:order_num => spItem['order_num'],
		:menu_section_id => sectionObj.id,
		:restaurant_id => sectionObj.restaurant_id
	)
	photos = spItem['photos']
	unless photos.nil? || photos.length <= 0
		photos.each do |url|
			menuItemObj.images = Array.new
			img = Image.new(
				:url => url,
				:menu_item_id => menuItemObj.id
			)
			menuItemObj.images << img
		end
	end
	itemAttr = spItem['attributes']
	unless itemAttr.nil?
		menuItemObj.dairy = itemAttr['dairy']
		menuItemObj.dairy_free = itemAttr['dairy-free']
		menuItemObj.egg = itemAttr['egg']
		menuItemObj.egg_free = itemAttr['egg-free']
		menuItemObj.fish = itemAttr['fish']
		menuItemObj.fish_free = itemAttr['fish-free']
		menuItemObj.gluten_free = itemAttr['gluten_free']
		menuItemObj.halal = itemAttr['halal']
		menuItemObj.kosher = itemAttr['kosher']
		menuItemObj.organic = itemAttr['organic']
		menuItemObj.peanut = itemAttr['peanut']
		menuItemObj.peanut_free = itemAttr['peanut_free']
		menuItemObj.shellfish = itemAttr['shellfish']
		menuItemObj.shellfish_free = itemAttr['shellfish_free']
		menuItemObj.soy = itemAttr['soy']
		menuItemObj.soy_free = itemAttr['soy-free']
		menuItemObj.spicy = itemAttr['spicy']
		menuItemObj.tree_nut = itemAttr['tree-nut']
		menuItemObj.tree_nut_free = itemAttr['tree-nut-free']
		menuItemObj.vegan = itemAttr['vegan']
		menuItemObj.vegetarian = itemAttr['vegetarian']
		menuItemObj.wheat = itemAttr['wheat']
	end
	spAdditions = spItem['additions']
	unless spAdditions.nil? || spAdditions.length === 0
		menuAdditionArr = Array.new
		spAdditions.each do |spAddition|
			menuAdditionObj = MenuAddition.create_menu_addition(spAddition)
			menuAdditionObj.menu_item = menuItemObj
			menuAdditionArr << menuAdditionObj
		end
		menuItemObj.menu_additions = menuAdditionArr
	end
	spChoices = spItem['choices']
	unless spChoices.nil? || spChoices.length === 0
		menuChoicesArr = Array.new
		spChoices.each do |spChoice|
			menuChoiceObj = MenuChoice.create_menu_choice(spChoice)
#			menuChoiceObj.menu_item_id = menuItemObj.id
			menuChoicesArr << menuChoiceObj
		end
		menuItemObj.menu_choices = menuChoicesArr
	end
	return menuItemObj
   end
end
