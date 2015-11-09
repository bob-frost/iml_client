module ImlClient
  
  class Error < StandardError

    attr_reader :code, :message

    def initialize(code, message)
      @code = code
      @message = message
    end

  end

  class ResponseError < Error; end

  class APIError < Error; end

end
