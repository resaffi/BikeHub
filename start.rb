require 'rubygems'
require 'json'
require "net/http"
require "uri"
require 'sinatra'
#require 'sinatra/reloader'
require 'redis'
require_relative 'redis_helper'
require_relative 'open_bike_api'
require_relative 'open_street_map_api'
require_relative 'helper'
require 'addressable/uri'
$r = Redis.new(url: ENV["REDIS_URL"])

open_bike_object = OpenBikeApi.new

response = open_bike_object.response

data =  JSON.parse(response)['DATA']

redis_geo_object= RedisGeoHelper.new($r,data)


get '/' do
    user_address = params[:address].to_s

    street = user_address.gsub(/\s+/, "%20")

    open_street_map_object = OpenStreetMapApi.new(street)

    response = open_street_map_object.response

    json_parsed = JSON.parse(response)[0]

    lat =  json_parsed["lat"] if defined?(json_parsed["lat"])
    long = json_parsed["lon"] if defined?(json_parsed["lon"])

    nearest =  redis_geo_object.nearest_bikes(lat,long)

    erb :index, :locals => {'user_address'=> user_address,'long'=>long, 'lat' => lat, 'nearest' => nearest}

end

