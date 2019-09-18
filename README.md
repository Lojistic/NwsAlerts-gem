# Nws::Api::Alerts

This gem provides a wrapper around the [NWS Weather Alerts API](https://www.weather.gov/documentation/services-web-alerts) which provides the ability to fetch and filter weather alert information throughout the United States. While subject to rate-limiting for the sake of abuse prevention, the NWS API is entirely free to use by anyone, which means that this gem will work out of the box without any configuration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nws-api-alerts'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nws-api-alerts

## Usage

You can get back a list of every alert currently in force throughout the country with the following code snippet:

```ruby
  client = Nws::Api::Alerts::Client.new
  alerts = client.get_alerts
```

The plan is to introduce parameters for filtering the list of returned alerts in a forthcoming release. For now, the list returned represents _every_ currently active alert in the country. These alerts are returned inside of an `AlertSet` object.

An `AlertSet` implements the `Enumerable` interface, which makes methods such as `each`, `map`, and `select` available on it. It also implements a handful of methods that allow it to behave somewhat like an array. For instance, you can call `first` and `last` on an `AlertSet`, in addition to dereferencing a particular `Alert` by it's index. Here's some examples of the array methods in action:

```ruby
  client = Nws::Api::Alerts::Client.new
  alerts = client.get_alerts

  first_alert = alerts.first # => Nws::Api::Alerts::Alert
  last_alert  = alerts.last  # => Nws::Api::Alerts::Alert

  nth_alert = alerts[2] # => Nws::Api::Alerts::Alert

```

Here are some examples of enumerating through an `AlertSet`:

```ruby
alerts = client.get_alerts

nws_ids     = alerts.map{|alert| alert.nws_id } # => Array
expirations = alerts.map(&:expires) # => Array

expired     = alerts.select{|alert| Time.parse(alert.expires) < Time.now } # => Array
```

### Filtering Alerts

An `AlertSet` can also be filtered based upon the severity, urgency, or certainty of the Alert, or any combination thereof. You can also choose to filter out Alerts that do not provide geometry data for mapping purposes.  Examples of these are below:

```ruby
  alerts = client.get_alerts

  severe_severity   = alerts.severe # => Nws::Api::Alerts::AlertSet
  moderate_severity = alerts.moderate # => Nws::Api::Alerts::AlertSet

  immediately_urgent = alerts.immediate # => Nws::Api::Alerts::AlertSet
  expected_urgency   = alerts.expected # => Nws::Api::Alerts::AlertSet

  observed_certainty = alerts.observed # => Nws::Api::Alerts::AlertSet
  possible_certainty = alerts.possible # => Nws::Api::Alerts::AlertSet

  # You can also chain together filters in any order, bearing in mind that filters within a given category are mutually exclusive.
  severe_immediate_observed_alerts = alerts.severe.immediate.observed # => Nws::Api::Alerts::AlertSet

```
The filters available for each "category": severity, urgency, and certainty, are as follows:

* Severity: `severe`, `moderate`, `minor`, `unknown_severity`
* Urgency: `immediate`, `expected`, `future`, `unknown_urgency`
* Certainty: `observed`, `possible`, `likely`, `unknown_certainty`

To filter the `AlertSet` based upon whether or not geographic map data is available, you can call `with_geography` and `without_geography` respectively.

### Alert Data

An `AlertSet` is ultimately a collection of `Alert` objects. An `Alert` instance currently doesn't do much more than store the attributes of a specific weather alert. The attributes/methods available on an `Alert` are as follows:

* `nws_id`: The unique identifier for this alert as assigned by the National Weather Service.
* `onset`: A timestamp referring to the time when the conditions described in the alert first began.
* `expires`: A timestamp referring to when the alert will no longer be in effect.
* `message_type`: Mostly used internally, currently will only ever be 'Alert'
* `severity`: A string describing the "severity" of the Alert, "Severe", "Moderate", "Minor", or "Unknown"
* `certainty`: A string describing the "certainty" of the Alert, "Observed", "Possible", "Likely", or "Unknown"
* `urgency`: A string describing the "urgency" of the Alert, "Immediate", "Expected", "Future", or "Unknown"
* `instruction`: A string describing the conditions of the alert and action recommended by local authorities for proceeding safely.
* `geometry`: An array of latitude, longitude pairs that describe a polygon over a geographic area. Used for displaying alert information on a map.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Lojistic/NwsAlerts-gem.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
