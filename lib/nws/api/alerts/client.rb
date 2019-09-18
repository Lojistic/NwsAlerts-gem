require 'httparty'

module Nws
  module Api
    module Alerts
      class Client
        include HTTParty
        base_uri "https://api.weather.gov"

        def get_alerts(message_type: 'alert', status: 'actual', urgency: nil, severity: nil, certainty: nil, limit: nil)
          parsed     = fetch_raw_alerts(message_type: message_type,
                                        status: status,
                                        urgency: urgency,
                                        severity: severity,
                                        certainty: certainty,
                                        limit: limit)
          alerts     = Alert.from_api_response(self, parsed)

          return alerts
        end

        def fetch_raw_alerts(message_type: 'alert', status: 'actual', urgency: nil, severity: nil, certainty: nil, limit: nil, path: nil)
          path ||= "/alerts?message_type=#{message_type}&status=#{status}"
          path << "&urgency=#{urgency}" if urgency
          path << "&severity=#{severity}" if severity
          path << "&certainty=#{certainty}" if certainty
          patch << "&limit=#{limit}" if limit
          raw_result = self.class.get(path)
          JSON.parse(raw_result)
        end

      end
    end
  end
end
