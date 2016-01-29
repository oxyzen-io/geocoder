require 'geocoder/results/base'

module Geocoder::Result
  class Naver < Base

    def coordinates
      [item['point']['y'], item['point']['x']]
    end

    def address(format = :full)
      item['address']
    end

    def country
      item['addrdetail']['country']
    end

    def country_code
      'KR'
    end

    def item
      items[0]
    end

    def items
      @data[1]['items']
    end

  end
end
