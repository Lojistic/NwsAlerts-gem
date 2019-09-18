require 'spec_helper'

RSpec.describe Nws::Api::Alerts::AlertSet do
  let(:fixture_path){ File.expand_path("#{File.dirname(__FILE__)}/../../../fixtures/") }
  let(:raw_data){ File.read("#{fixture_path}/nws_alert_response.json") }
  let(:alert_array){ JSON.parse(raw_data)['features'].map{|rd| Nws::Api::Alerts::Alert.new(rd) } }
  let(:alert_set) { Nws::Api::Alerts::AlertSet.new(alert_array) }

  describe "#new" do
    it "should set it's internal `alerts` attribute to the passed array of Alerts" do
      expect(alert_set.alerts).to eq(alert_array)
    end

  end

  context "the Enumerable implementation" do

    it "should add the passed alert to the AlertSet when calling #<<" do
      alert = alert_array.shift

      short_alert_set = Nws::Api::Alerts::AlertSet.new(alert_array)

      expect(short_alert_set.alerts).to_not include(alert)

      alert_set << alert

      expect(short_alert_set.alerts).to include(alert)
    end

    it "should iterate through the underlying alerts array when calling #each" do
      alert_set.each_with_index do |alert, idx|
        expect(alert_array[idx]).to eq(alert)
      end
    end

    it "should return the alert in the alert array at the specified index when calling #[]" do
      (0..alert_array.length - 1).each do |i|
        expect(alert_set[i]).to eq(alert_array[i])
      end
    end

    it "should return the first element of the alert array when calling #first" do
      expect(alert_set.first).to eq(alert_array.first)
    end

    it "should return the last element of the alert array when calling #last" do
      expect(alert_set.last).to eq(alert_array.last)
    end

  end

  context "alert filtering" do

    describe "the severity filters" do

      it "should return severe severity weather alerts when you call #severe" do
        expect(alert_set.severe.map(&:severity).uniq).to eq(['Severe'])
      end

      it "should return moderate serverity weather alerts when you call #moderate" do
        expect(alert_set.moderate.map(&:severity).uniq).to eq(['Moderate'])
      end

      it "should return minor severity weather alerts when you call #minor" do
        expect(alert_set.minor.map(&:severity).uniq).to eq(['Minor'])
      end

      it "should return unknown severity weather alerts when you call #unknown_severity" do
        expect(alert_set.unknown_severity.map(&:severity).uniq).to eq(['Unknown'])
      end

    end

    describe "the urgency filters" do

      # Sample data doesn't include 'past' because we don't usually care about the
      # past. Keeping this commented though to document the _option_ of calling it.
      #it "returns past urgency weather alerts when you call #past" do
        #expect(alert_set.past.map(&:urgency).uniq) .to eq(['Past'])
      #end

      it "should return immediate urgency weather alerts when you call #immediate" do
        expect(alert_set.immediate.map(&:urgency).uniq) .to eq(['Immediate'])
      end

      it "should return expected urgency weather alerts when you call #expected" do
        expect(alert_set.expected.map(&:urgency).uniq) .to eq(['Expected'])
      end

      it "should return future urgency weather alerts when you call #future" do
        expect(alert_set.future.map(&:urgency).uniq) .to eq(['Future'])
      end

      it "should return unknown urgency weather alerts when you call #unknown_urgency" do
        expect(alert_set.unknown_urgency.map(&:urgency).uniq) .to eq(['Unknown'])
      end

    end

    describe "the certainty filters" do

      it "should return observed certainty weather alerts when you call #observed" do
        expect(alert_set.observed.map(&:certainty).uniq) .to eq(['Observed'])
      end

      it "should return likely certainty weather alerts when you call #likely" do
        expect(alert_set.likely.map(&:certainty).uniq) .to eq(['Likely'])
      end

      it "should return possible certainty weather alerts when you call #possible" do
        expect(alert_set.possible.map(&:certainty).uniq) .to eq(['Possible'])
      end

      it "should return unknown certainty weather alerts when you call #unknown_certainty" do
        expect(alert_set.unknown_certainty.map(&:certainty).uniq) .to eq(['Unknown'])
      end

    end

    describe "geometry filtering" do

      it "should exclude alerts without geometry when you call #with_geometry" do
        expect(alert_set.without_geometry.map(&:geometry).uniq).to eq([nil])
      end

      it "should exclude alerts with geometry when you call #without_geometry" do
        expect(alert_set.with_geometry.map(&:geometry).uniq).to_not include(nil)
      end

    end

    describe "filter chaining" do

      it "can apply multiple filters" do
        result = alert_set.severe.immediate.observed

        expect(result.map(&:severity).uniq).to eq(['Severe'])
        expect(result.map(&:certainty).uniq).to eq(['Observed'])
        expect(result.map(&:urgency).uniq).to eq(['Immediate'])
      end

    end

  end

end
