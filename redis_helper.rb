class RedisGeoHelper
    attr_accessor :client,:data

    GeoNode = Struct.new(:address,:lat,:long)

    def initialize(client,data)
        @client = client
        @data = GeoNodify(data)
        add_geodata_from_api(@data)
    end

    def add_geodata_from_api(data)
        data.each { |elem| client.geoadd "bikes",elem.lat,elem.long,elem.address}
    end

    def make_address(elem)
        street = elem[3]
        number = elem[4].to_i
        address = (number!=0)? "#{street}, #{number.to_s}" : street
        return address

    end

    def nearest_bikes(lat,long,radius = 50000)
        client.georadius "bikes",lat,long,radius,"m","WITHCOORD","WITHDIST","COUNT",5,"ASC" 
    end


    def GeoNodify(data)
        data.map{ |elem| GeoNode.new(make_address(elem),elem[5].to_f,elem[6].to_f) } 
    end
end


