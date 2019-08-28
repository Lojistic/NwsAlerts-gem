# The Alert class encapsulates all of the important information for a given weather alert


module Nws
  module Api
    module Alerts
      class Alert

        attr_reader :onset, :expires, :message_type, :severity, :certainty, :urgency, :instruction, :geometry_type, :geometry

        def self.from_api_response(parsed_response)
          alerts = AlertSet.new
          parsed_response['features'].each do |alert_data|
            alerts << self.new(alert_data)
          end

          return alerts
        end


        def initialize(data)

          if data['geometry']
            @geometry_type = data['geometry']['type']
            @geometry      = data['geometry']['coordinates']
          end

          properties     = data['properties']
          @onset         = properties['onset']
          @expires       = properties['expires']
          @message_type  = properties['messageType']
          @severity      = properties['severity']
          @certainty     = properties['certainty']
          @urgency       = properties['urgency']
          @instruction   = properties['instruction']
        end

      end
    end
  end
end
