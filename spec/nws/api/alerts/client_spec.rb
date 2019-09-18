require 'spec_helper'

RSpec.describe Nws::Api::Alerts::Client do

  describe "#get_alerts" do
    it "should return an AlertSet" do
      expect(Nws::Api::Alerts::Client).to receive(:get).and_return("{}")

      client = Nws::Api::Alerts::Client.new
      alerts = client.get_alerts

      expect(alerts).to be_a Nws::Api::Alerts::AlertSet
    end
  end

  describe "#fetch_raw_alerts" do
    it "should return parsed JSON" do
      client = Nws::Api::Alerts::Client.new
      raw_alerts = client.fetch_raw_alerts

      expect(raw_alerts).to be_a Hash
    end
  end

end
