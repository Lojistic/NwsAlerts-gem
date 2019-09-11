require 'httparty'

module Nws
  module Api
    module Alerts
      class Client
        include HTTParty
        base_uri "https://api.weather.gov"

        def get_alerts
          parsed     = fetch_raw_alerts
          alerts     = Alert.from_api_response(self, parsed)

          return alerts
        end

        def fetch_raw_alerts(path = nil)
          path ||=  "/alerts?message_type=alert&status=actual"
          raw_result = self.class.get(path)
          JSON.parse(raw_result)
        end

      end
    end
  end
end
