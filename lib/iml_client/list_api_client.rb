require 'iml_client/abstract_api_client'
require 'iml_client/util'

module ImlClient
  class ListApiClient < AbstractApiClient

    def initialize(login, password)
      @login    = login
      @password = password
    end

    def locations(params = {})
      result = request_and_normalize url_for(:locations), :get, nil, nil, response_normalization_rules_for(:locations), []
      unless params[:IncludeNotOpened]
        result.data.select!{ |d| !d[:OpeningDate].is_a?(Date) || d[:OpeningDate] <= Date.today }
      end
      unless params[:IncludeClosed]
        result.data.select!{ |d| !d[:ClosingDate].is_a?(Date) || d[:ClosingDate] > Date.today }
      end
      result
    end

    def exception_service_regions(params = {})
      result = request_and_normalize url_for(:exception_service_regions), :get, nil, nil, response_normalization_rules_for(:exception_service_regions), []
      unless params[:IncludeNotOpened]
        result.data.select!{ |d| !d[:Open].is_a?(Date) || d[:Open] <= Date.today }
      end
      unless params[:IncludeEnded]
        result.data.select!{ |d| !d[:End].is_a?(Date) || d[:End] > Date.today }
      end
      result
    end

    def regions
      request_and_normalize url_for(:regions), :get, nil, nil, response_normalization_rules_for(:regions), []
    end

    def pickup_points(params = {})
      region_code = params[:RegionCode]
      method = Util.blank?(region_code) ? :get : :post
      result = request_and_normalize url_for(:pickup_points), method, nil, region_code, response_normalization_rules_for(:pickup_points), []
      unless params[:IncludeNotOpened]
        result.data.select!{ |d| !d[:OpeningDate].is_a?(Date) || d[:OpeningDate] <= Date.today }
      end
      unless params[:IncludeClosed]
        result.data.select!{ |d| !d[:ClosingDate].is_a?(Date) || d[:ClosingDate] > Date.today }
      end
      result
    end

    def status_types
      request_and_normalize url_for(:status_types), :get, nil, nil, response_normalization_rules_for(:status_types), []
    end

    def post_codes
      request_and_normalize url_for(:post_codes), :get, nil, nil, response_normalization_rules_for(:post_codes), []
    end

    def services
      request_and_normalize url_for(:services), :get, nil, nil, response_normalization_rules_for(:services), []
    end

    def zones
      request_and_normalize url_for(:zones), :get, nil, nil, response_normalization_rules_for(:zones), []
    end

    protected

    def host
      ImlClient::LIST_API_HOST
    end

    def request(url, method, request_params, params)
      request_params ||= {}
      request_params[:headers] ||= {}
      request_params[:headers]['Content-Type'] = 'application/json'
      request_params[:basic_auth] = { username: @login, password: @password }

      raw_request url, method, request_params, params
    end

  end
end
