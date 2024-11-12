module Iyzipay
  module Model
    class ThreedsPayment < IyzipayResource

      def create(request = {}, options)
        pki_string = to_pki_string_create(request)
        request_path = "/payment/iyzipos/auth3ds/ecom"
        HttpClient.post("#{options.base_url}#{request_path}", get_http_header(request_path, pki_string, options), request.to_json)
      end

      def retrieve(request = {}, options)
        pki_string = to_pki_string_retrieve(request)
        request_path = "/payment/detail"
        HttpClient.post("#{options.base_url}#{request_path}", get_http_header(request_path, pki_string, options), request.to_json)
      end

      def to_pki_string_create(request)
        PkiBuilder.new.
            append(:locale, request[:locale]).
            append(:conversationId, request[:conversationId]).
            append(:paymentId, request[:paymentId]).
            append(:conversationData, request[:conversationData]).
            get_request_string
      end

      def to_pki_string_retrieve(request)
        PkiBuilder.new.
            append(:locale, request[:locale]).
            append(:conversationId, request[:conversationId]).
            append(:paymentId, request[:paymentId]).
            append(:paymentConversationId, request[:paymentConversationId]).
            get_request_string
      end
    end
  end
end