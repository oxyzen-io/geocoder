require 'geocoder/lookups/base'
require "geocoder/results/naver"

module Geocoder::Lookup
  class Naver < Base

    def name
      "Naver"
    end

    def required_api_key_parts
      ["key"]
    end

    def query_url(query)
      (query.reverse_geocode? ?
        "#{protocol}://openapi.map.naver.com/api/reversegeocode?" :
        "#{protocol}://openapi.map.naver.com/api/geocode?") +
      url_query_string(query)
    end

    # HTTP only
    def supported_protocols
      [:http]
    end

    private # ---------------------------------------------------------------

    def results(query, reverse = false)
      return [] unless doc = fetch_data(query)
      if doc != nil
        return doc
      else
        case doc['error']['code']
        when 000
          raise_error(Geocoder::Error, messages) ||
          Geocoder.log(:warn, "Naver Geocoding API error: #{messages}")
        when 010
          raise_error(Geocoder::OverQueryLimitError, messages) ||
          Geocoder.log(:warn, "Naver Geocoding API error: #{messages}")
        when 011, 012
          raise_error(Geocoder::InvalidRequest, messages) ||
          Geocoder.log(:warn, "Naver Geocoding API error: #{messages}")
        when 020
          raise_error(Geocoder::InvalidApiKey, messages) ||
          Geocoder.log(:warn, "Naver Geocoding API error: #{messages}")
        end
      end
    end

    def query_url_params(query)
      { :query => query.sanitized_text,
        :key => configuration.api_key,
        :encoding => "utf-8",
        :coord => "latlng",
        :output => "json"
      }.merge(super)
    end

  end
end
