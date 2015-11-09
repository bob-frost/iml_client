require 'httparty'
require 'json'

require 'iml_client/errors'
require 'iml_client/result'
require 'iml_client/util'

module ImlClient
  class AbstractApiClient

    protected

    def format_request_date(date_or_time)
      date_or_time.strftime ImlClient::REQUEST_DATE_FORMAT
    end

    def normalize_request_data(data)
      case data
      when Hash
        result = {}
        data.each do |key, value|
          result[key.to_sym] = normalize_request_data value
        end
        return result
      when Array
        result = []
        data.each do |value|
          result.push normalize_request_data(value)
        end
        return result
      when Date, Time
        return format_request_date data
      else
        return data
      end
    end

    def normalize_response_data(data, rules, keypath = [])
      if data.nil? || (data.is_a?(String) && data.strip.empty?)
        return nil
      end

      case data
      when Hash
        result = {}
        data.each do |key, value|
          key = key.to_sym
          result[key] = normalize_response_data value, rules, keypath + [key]
        end
        return result
      when Array
        result = []
        data.each do |value|
          result.push normalize_response_data(value, rules, keypath)
        end
        return result
      else
        rule = rules.nil? ? nil : Util.hash_value_at_keypath(rules, keypath)
        case rule
        # when :to_i, :to_f
        #   return data.send rule
        when :to_date
          begin
            return Date.parse data
          rescue ArgumentError => e
            puts "Couldn't parse date '#{data}' at #{keypath.join '.'} with #{e.class.name}: #{e.message}!"
            return data
          end
        # when :to_time
        #   begin
        #     return Time.parse data
        #   rescue ArgumentError => e
        #     puts "Couldn't parse time '#{data}' at #{keypath.join '.'} with #{e.class.name}: #{e.message}!"
        #     return data
        #   end
        else
          return data
        end
      end
    end

    def host
      raise '`host` method should be defined in child class'
    end

    def url_for(key)
      URI.join("https://#{host}", ImlClient::API_PATHS[key]).to_s
    end

    def response_normalization_rules_for(key)
      ImlClient::RESPONSE_NORMALIZATION_RULES[key]
    end

    def request(url, method, request_params, params)
      raise '`request` method should be defined in child class'
    end

    def request_and_normalize(url, method, request_params, params, normalization_rules, empty_data)
      result = request url, method, request_params, params
      if result.errors.any?
        result.set_data empty_data
      else
        normalized_data = normalize_response_data result.data, normalization_rules
        result.set_data normalized_data
      end
      result
    end

    def raw_request(url, method, request_params, params)
      if !Util.blank?(params)
        if method == :post
          request_params = request_params.merge body: params.to_json
        else
          request_params = request_params.merge query: params
        end
      end

      begin
        response = HTTParty.send method, url, request_params
        if response.code == 200
          return ImlClient::Result.new response, response.parsed_response
        else
          error = ImlClient::ResponseError.new response.code, response.message
          return ImlClient::Result.new response, nil, [error]
        end
      rescue HTTParty::ResponseError => e
        error = ImlClient::ResponseError.new e.response.code, e.response.message
        return ImlClient::Result.new e.response, nil, [error]
      rescue Timeout::Error, Errno::ETIMEDOUT => e
        return ImlClient::Result.new nil, nil, [e]
      end
    end

  end
end
