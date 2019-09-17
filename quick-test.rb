require "bundler/setup"
require "nws/api/alerts"

client = Nws::Api::Alerts::Client.new
alerts  =  client.get_alerts



