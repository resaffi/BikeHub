module Helper
    def request_to_response(url)
        uri = Addressable::URI.parse(url)
        response = Net::HTTP.get(uri)
        response.force_encoding('iso-8859-1')
        return response
    end

end
