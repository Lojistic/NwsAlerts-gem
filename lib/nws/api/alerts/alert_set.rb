# The AlertSet class implements Enumerable, (each, map, select, etc), and
# provides convenience methods for filtering a collection of Alerts

module Nws
  module Api
    module Alerts
      class AlertSet
        include Enumerable
        attr_reader :alerts

        def initialize(alerts = nil)
          @alerts = alerts.is_a?(Array) ? alerts : []
        end

        def <<(alert)
          @alerts << alert
        end

        def each(&block)
          alerts.each(&block)
          self
        end

        alias length count
        alias size count

        def [](idx)
          alerts[idx]
        end

        def first
          alerts.first
        end

        def last
          alerts.last
        end

        def severe
          severity_filter_for('Severe')
        end

        def minor
          severity_filter_for('Minor')
        end

        def moderate
          severity_filter_for('Moderate')
        end

        def unknown_severity
         severity_filter_for('Unknown')
        end

        def past
          urgency_filter_for('Past')
        end

        def immediate
          urgency_filter_for('Immediate')
        end

        def expected
          urgency_filter_for('Expected')
        end

        def future
          urgency_filter_for('Future')
        end

        def unknown_urgency
          urgency_filter_for('Unknown')
        end

        def observed
          certainty_filter_for('Observed')
        end

        def possible
          certainty_filter_for('Possible')
        end

        def likely
          certainty_filter_for('Likely')
        end

        def unknown_certainty
          certainty_filter_for('Unknown')
        end

        def with_geometry
          return self.class.new(self.select{|alert| alert.geometry })
        end

        def without_geometry
          return self.class.new(self.reject{|alert| alert.geometry })
        end

        private

        def severity_filter_for(severity)
          return self.class.new(self.select{|alert| alert.severity == severity })
        end

        def urgency_filter_for(urgency)
          return self.class.new(self.select{|alert| alert.urgency == urgency })
        end

        def certainty_filter_for(certainty)
          return self.class.new(self.select{|alert| alert.certainty == certainty })
        end

      end
    end
  end
end

