module ImlClient
  module Util

    extend self

    def symbolize_keys(hash)
      result = {}
      hash.each do |key, value|
        result[key.to_sym] = value
      end
      result
    end

    def hash_value_at_keypath(hash, keypath)
      if keypath.length == 0 || !hash.is_a?(Hash)
        return nil
      elsif keypath.length == 1
        return hash[keypath[0]]
      else
        return hash_value_at_keypath hash[keypath[0]], keypath[1..-1]        
      end
    end

    def blank?(value)
      value.nil? || 
      (value.is_a?(String) && value.strip == '') ||
      ((value.is_a?(Array) || (value.is_a?(Hash))) && value.empty?)
    end

    def array_wrap(value)
      if value.is_a? Array
        return value
      elsif value.nil?
        return []
      else
        return [value]
      end
    end

  end
end
