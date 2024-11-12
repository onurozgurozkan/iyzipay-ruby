module Iyzipay
  class IyzipayResource

    AUTHORIZATION_HEADER_NAME = 'Authorization'
    RANDOM_HEADER_NAME = 'x-iyzi-rnd';
    AUTHORIZATION_HEADER_STRING = 'IYZWSv2 %s'
    RANDOM_STRING_SIZE = 8
    RANDOM_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

    def get_http_header(request_path, pki_string = nil, options = nil, authorize_request = true)
      header = {:accept => 'application/json',
                :'content-type' => 'application/json'}

      if authorize_request
        random_key = random_string(RANDOM_STRING_SIZE)
        authorization = prepare_authorization_string(request_path, pki_string, random_key, options)
        header[:'Authorization'] = authorization
        header[:'x-iyzi-rnd'] = "#{random_key}"
        header[:'x-iyzi-client-version'] = 'iyzipay-ruby-1.0.45'
      end

      header
    end

    def get_plain_http_header
      get_http_header(nil, false)
    end

    def prepare_authorization_string(request_path, pki_string, random_key, options)
      encrypted_data = calculate_hash(request_path, pki_string, random_key, options)
      authorization_string = "apiKey:#{options.api_key}&randomKey:#{random_key}&signature:#{encrypted_data}"
      base64_encoded = Base64.strict_encode64(authorization_string)
      format_header_string(base64_encoded)
    end

    def json_decode(response, raw_result)
      json_result = JSON::parse(raw_result)
      response.from_json(json_result)
    end

    def calculate_hash(request_path, pki_string, random_key, options)
      # payload: randomKey + uri.path + request_body
      payload = if pki_string.nil?
                 "#{random_key}#{request_path}"
               else
                 "#{random_key}#{request_path}#{pki_string}"
               end

      OpenSSL::HMAC.hexdigest('SHA256', options.secret_key, payload)
    end

    def format_header_string(*args)
      sprintf(AUTHORIZATION_HEADER_STRING, *args)
    end

    def random_string(string_length)
      random_string = ''
      string_length.times do
        random_string << RANDOM_CHARS.split('').sample
      end
      random_string
    end

    def to_pki_string(request)
      PkiBuilder.new.append(:locale, request[:locale]).
          append(:conversationId, request[:conversationId]).
          get_request_string
    end
  end
end
