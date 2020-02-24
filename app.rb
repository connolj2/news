require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your News API key here
ForecastIO.api_key = "3c86ac58556d447d93d2dd4e13ca452a"

get "/" do
results = Geocoder.search(params["q"])
    @lat_long = results.first.coordinates # => [lat, long]
    @location = results.first.city
# Define the lat and long
@lat = "#{lat_long [0]}"
@long = "#{lat_long [1]}"
# Results from Geocoder
@forecast = ForecastIO.forecast("#{lat}" , "#{long}").to_hash
@current_temperature = forecast["currently"]["temperature"]
@conditions = forecast["currently"]["summary"]
puts "In #{location}, it is currently #{current_temperature} and #{conditions}"
# high_temperature = forecast["daily"]["data"][0]["temperatureHigh"]
# puts high_temperature
# puts forecast["daily"]["data"][1]["temperatureHigh"]
# puts forecast["daily"]["data"][2]["temperatureHigh"]
for @daily_forecast in forecast["daily"]["data"]
  puts "A high temperature of #{day["temperatureHigh"]} and #{day["summary"]}."
end
pp ask
view ask
end

get "/news" do
    @location = params["LocationInputBox"]    @geocoder_results = Geocoder.search(@location)
    @lat_long = @geocoder_results.first.coordinates # => [lat, long] array   
    @url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=3c86ac58556d447d93d2dd4e13ca452a"
    news = HTTParty.get(@url).parsed_response.to_hash    
    pp news
    view news
end
