require_relative 'helper'
require 'json'
class OpenStreetMapApi
    extend Helper
    attr_accessor :response, :street, :url
    def initialize(street)
        @street = street
        @url = "http://nominatim.openstreetmap.org/search?street=#{@street}&city=rio+de+janeiro&format=json" 
        @response = OpenStreetMapApi.request_to_response(@url)
    end


end

