require "bundler/setup"
require "nws/api/alerts"

client = Nws::Api::Alerts::Client.new
alerts =  client.get_alerts

pp alerts.with_geometry.count
pp alerts.without_geometry.count


