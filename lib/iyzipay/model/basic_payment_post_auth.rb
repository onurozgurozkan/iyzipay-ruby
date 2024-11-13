module Iyzipay
  module Model
    class BasicPaymentPostAuth < IyzipayResource

      def create(request = {}, options)
        pki_string = to_pki_string(request)
        request_path = "/payment/iyziconnect/postauth"
        HttpClient.post("#{options.base_url}#{request_path}", get_http_header(request_path, pki_string, options), request.to_json)
      end

      def to_pki_string(request)
        PkiBuilder.new.append_super(super).
            append(:paymentId, request[:paymentId]).
            append(:ip, request[:ip]).
            append_price(:paidPrice, request[:paidPrice]).
            append(:currency, request[:currency]).
            get_request_string
      end
    end
  end
end