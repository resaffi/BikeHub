require 'rubygems'
require 'json'
require "net/http"
require "uri"
require 'sinatra'
#require 'sinatra/reloader'
require 'redis'
require 'addressable/uri'

$r = Redis.new
def request_to_json(url)
    uri = Addressable::URI.parse(url)
    response = Net::HTTP.get(uri).to_s
    response.force_encoding('iso-8859-1')
    json_response = JSON.parse(response)
    puts json_response
    return json_response
end

def add_to_redis(data)
    data.each do  |elem| 
        rua = elem[3]
        numero = elem[4].to_i
        if numero != 0
            address = rua +", " +  numero.to_s
        else
            address = rua
        end
        lat = elem[5].to_f
        long = elem[6].to_f
        $r.geoadd "bikes",lat,long,address

    end
end


url = "http://dadosabertos.rio.rj.gov.br/apiTransporte/apresentacao/rest/index.cfm/estacoesBikeRio"
data =  request_to_json(url)['DATA']
add_to_redis(data)
#result =  r.georadius "bikes",-20.0,22.0,10000,"km","WITHDIST","ASC"
get '/' do
    user_address = params[:address].to_s
    street = user_address.gsub(/\s+/, "%20")
    url = "http://nominatim.openstreetmap.org/search?street=#{street}&city=rio+de+janeiro&format=json"
    uri = Addressable::URI.parse(url)
    response = Net::HTTP.get(uri)
    json_parsed = JSON.parse(response)[0]
    lat =  json_parsed["lat"] if defined?(json_parsed["lat"])
    long = json_parsed["lon"] if defined?(json_parsed["lon"])
    nearest =  $r.georadius "bikes",lat,long,500000,"m","WITHCOORD","WITHDIST","COUNT",5,"ASC"
    erb :index, :locals => {'user_address'=> user_address,'long'=>long, 'lat' => lat, 'nearest' => nearest}

end

