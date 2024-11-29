
require 'net/http'
require 'uri'
require 'json'

class TicketCreationService

    def initialize(payload)
      @payload = payload
      @api_url = ENV['TICKETS_API_URL'] || 'https://example.com/api/v1/tickets'
    end
  
    def call
      retries ||= 0
      uri = URI(@api_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
    
      request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
      request.body = @payload.to_json
    
      begin
        response = http.request(request)
        response_body = JSON.parse(response.body)
    
        if response.code.to_i == 201 || response_body['status'] == "OK"
          { success: true, data: response_body }
        else
          { success: false, error: response_body['error'] || 'Error desconocido' }
        end
      rescue StandardError => e
        if (retries += 1) <= 3
          retry
        else
          { success: false, error: "Error tras 3 reintentos: #{e.message}" }
        end
      end
    end
    
  end
  
  