	require "sinatra"
	require "sinatra/reloader"
	require "geocoder"
	require "forecast_io"
	require "httparty"
	def view(template); erb template.to_sym; end
	before { puts "Parameters: #{params}" } 
	
	# enter your Dark Sky API key here
    ForecastIO.api_key = "51e4b49310a5972db76a499bc4d0159a"

    get "/" do
    #show a view that asks user for a location
    view "ask"
	end

	get "/news" do
	
    #enter parameters and get latlong
    @results = Geocoder.search(params["q"])
    @location = params["q"]
    @latlong = @results.first.coordinates
    lat = "#{latlong[0]}"
    long = "#{latlong[1]}"
  
	#get current forecast 
	@forecast = ForecastIO.forecast("#{lat}","#{long}").to_hash 
	@current_temperature = @forecast["currently"]["temperature"]
	@conditions = @forecast["currently"]["summary"]
	
	#get forecast
	daily_high = []
	day_condition = []
	for day in @forecast["daily"]["data"]
	daily_high << "#{day["temperatureHigh"]}"
	day_condition << "#{day["summary"]}"
	#"A high temperature of #{day["temperatureHigh"]} and #{day["summary"]}."
	end
	@temp = daily_high
	@condition = day_condition
	
	#get the news
	@url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=3c86ac58556d447d93d2dd4e13ca452a"
	@news = HTTParty.get(@url).parsed_response.to_hash
	
	#create arrays for links and headlines
	headline_url = []
	for headlines in @news["articles"]
	headline_url << "#{headlines["url"]}"
    end
    @headline = headline_url
	
	headline_title = []
	for headlinetitles in @news["articles"]
	headline_title << "#{headlinetitles["title"]}"
	end
	@titles = headline_title
	
	view "news"
	end
	
