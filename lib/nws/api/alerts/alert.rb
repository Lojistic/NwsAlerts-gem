# The Alert class encapsulates all of the important information for a given weather alert


module Nws
  module Api
    module Alerts
      class Alert

        attr_reader :nws_id, :onset, :expires, :message_type, :severity, :certainty, :urgency, :instruction, :geometry

        def self.from_api_response(client, parsed_response, alerts = nil)
          alerts ||= AlertSet.new
          return alerts unless parsed_response['features']
          parsed_response['features'].each do |alert_data|
            alerts << self.new(alert_data)
          end

          if parsed_response['pagination'] && parsed_response['pagination']['next']
            next_uri = URI.parse(parsed_response['pagination']['next'])
            next_path = next_uri.to_s.gsub("#{next_uri.scheme}://#{next_uri.host}", '')

            self.from_api_response(client, client.fetch_raw_alerts(path: next_path), alerts)
          end

          return alerts
        end


        def initialize(data)

          if data['geometry']
            @geometry    = data['geometry']['coordinates'].first
          end

          properties     = data['properties']
          @nws_id        = properties['id']
          @onset         = properties['onset']
          @expires       = properties['expires']
          @message_type  = properties['messageType']
          @severity      = properties['severity']
          @certainty     = properties['certainty']
          @urgency       = properties['urgency']
          @instruction   = properties['instruction']
        end

        def attributes
          hsh = {}
          # Give back a hash of attributes suitable for persistance to a DB, for instance.
          instance_variables.map(&:to_s).map{|iv| iv.gsub('@', '')}.map{|att| hsh[att.to_sym] = self.send(att.to_sym)}

          hsh
        end


      end
    end
  end
end
