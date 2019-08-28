require 'httparty'

module Nws
  module Api
    module Alerts
      class Client
        include HTTParty
        base_uri "https://api.weather.gov"

        def get_alerts
          raw_result = self.class.get("/alerts?status=actual")
          parsed     = JSON.parse(raw_result)
          alerts     = Alert.from_api_response(parsed)

          return alerts
        end

      end
    end
  end
end
