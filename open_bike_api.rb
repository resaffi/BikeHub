require_relative 'helper'
class OpenBikeApi
    extend Helper
    attr_accessor :url,:response

    def initialize
        @url = "http://dadosabertos.rio.rj.gov.br/apiTransporte/apresentacao/rest/index.cfm/estacoesBikeRio" 
        @response = OpenBikeApi.request_to_response(url)
    end

end
