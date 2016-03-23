require 'iml_client/abstract_api_client'
require 'iml_client/errors'
require 'iml_client/util'

module ImlClient
  class RestApiClient < AbstractApiClient

    DEFAULT_TIMEOUT = 1

    def initialize(login, password, options = {})
      @login    = login
      @password = password
      options = Util.symbolize_keys options
      @test_mode = !!options[:test_mode]
      @timeout = options[:timeout] || DEFAULT_TIMEOUT
    end

    def orders(params = {})
      request_and_normalize url_for(:orders), :post, nil, params, response_normalization_rules_for(:orders), []
    end

    def order_statuses(params = {})
      request_and_normalize url_for(:order_statuses), :post, nil, params, response_normalization_rules_for(:order_statuses), []
    end

    def create_order(params)
      result = request url_for(:create_order), :post, nil, params
      if result.errors.any?
        result.set_data({})
      elsif result.data['Result'] == 'Error'
        result.data['Errors'].each do |error_data|
          error = ImlClient::APIError.new error_data['Code'], error_data['Message']
          result.add_error error
        end
        result.set_data({})
      else
        normalized_data = normalize_response_data result.data['Order'], response_normalization_rules_for(:create_order)
        result.set_data normalized_data
      end
      result
    end

    def calculate_price(params)
      result = request url_for(:calculate_price), :post, nil, params
      if result.errors.any?
        result.set_data nil
      elsif !result.data.is_a?(Hash) || result.data['Price'].nil?
        Util.array_wrap(result.data).each do |error_data|
          error = ImlClient::APIError.new error_data['Code'], error_data['Mess']
          result.add_error error
        end
        result.set_data nil
      else
        result.set_data result.data['Price']
      end
      result
    end

    def test_mode?
      @test_mode
    end

    protected

    def host
      ImlClient::REST_API_HOST
    end

    def request(url, method, request_params, params)
      request_params ||= {}
      request_params[:headers] ||= {}
      request_params[:headers]['Content-Type'] = 'application/json'
      request_params[:basic_auth] = { username: @login, password: @password }
     
      params = normalize_request_data params
      params[:Test] = test_mode? ? 'True' : 'False'

      raw_request url, method, request_params, params
    end

  end
end
