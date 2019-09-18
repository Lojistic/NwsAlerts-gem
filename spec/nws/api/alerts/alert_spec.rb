require 'spec_helper'

RSpec.describe Nws::Api::Alerts::Alert do

  let(:fixture_path){ File.expand_path("#{File.dirname(__FILE__)}/../../../fixtures/") }
  let(:raw_data){ File.read("#{fixture_path}/nws_alert_response.json") }
  let(:raw_data_paged){ File.read("#{fixture_path}/nws_alert_response_paged.json") }

  describe "::from_api_response" do

    it "should return an AlertSet" do
      client    = instance_double(Nws::Api::Alerts::Client)
      alert_set = Nws::Api::Alerts::Alert.from_api_response(client, JSON.parse(raw_data))

      expect(alert_set).to be_a Nws::Api::Alerts::AlertSet
    end

    context "when it receives a paged response" do

      it "should attempt to retrieve the next page of results" do
        client    = instance_double(Nws::Api::Alerts::Client)
        expect(client).to receive(:fetch_raw_alerts).and_return("{}")
        alert_set = Nws::Api::Alerts::Alert.from_api_response(client, JSON.parse(raw_data_paged))

        expect(alert_set).to be_a Nws::Api::Alerts::AlertSet
      end

    end

  end

  describe "#new" do
    let(:alert_data){ JSON.parse(raw_data)['features'].first }

    it "should set attributes based on alert data" do
      alert = Nws::Api::Alerts::Alert.new(alert_data)

      expect(alert.nws_id).to eq(alert_data['properties']['id'])
      expect(alert.onset).to eq(alert_data['properties']['onset'])
      expect(alert.expires).to eq(alert_data['properties']['expires'])
      expect(alert.message_type).to eq(alert_data['properties']['messageType'])
      expect(alert.severity).to eq(alert_data['properties']['severity'])
      expect(alert.certainty).to eq(alert_data['properties']['certainty'])
      expect(alert.urgency).to eq(alert_data['properties']['urgency'])
      expect(alert.instruction).to eq(alert_data['properties']['instruction'])
    end

    it "should set geometry when it's available" do
      alert = Nws::Api::Alerts::Alert.new(alert_data)
      expect(alert.geometry).to_not be_nil
    end

    it "should not set geometry when it's not available" do
      no_geo_alert_data = JSON.parse(raw_data)['features'][1]
      alert = Nws::Api::Alerts::Alert.new(no_geo_alert_data)

      expect(alert.geometry).to be_nil
    end
  end
end
