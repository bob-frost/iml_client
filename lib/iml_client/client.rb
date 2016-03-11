require 'iml_client/list_api_client'
require 'iml_client/rest_api_client'
require 'iml_client/util'

module ImlClient
  class Client

    def initialize(login, password, options = {})
      @login    = login
      @password = password
      options = Util.symbolize_keys options
      @test_mode = !!options[:test_mode]
    end

    def orders(params = {})
      rest_api_client.orders params
    end

    def order_statuses(params = {})
      rest_api_client.order_statuses params
    end

    def create_order(params)
      rest_api_client.create_order params
    end

    def calculate_price(params)
      rest_api_client.calculate_price params
    end

    def locations(params = {})
      list_api_client.locations params
    end

    def exception_service_regions(params = {})
      list_api_client.exception_service_regions params
    end

    def regions
      list_api_client.regions
    end

    def pickup_points(params = {})
      list_api_client.pickup_points params
    end

    def status_types
      list_api_client.status_types
    end

    def post_codes
      list_api_client.post_codes
    end

    def services
      list_api_client.services
    end

    def zones
      list_api_client.zones
    end

    def test_mode?
      @test_mode
    end

    private

    def rest_api_client
      @rest_api_client ||= RestApiClient.new @login, @password, test_mode: test_mode?
    end

    def list_api_client
      @list_api_client ||= ListApiClient.new @login, @password
    end

  end
end
