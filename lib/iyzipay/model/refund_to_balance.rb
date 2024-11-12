module Iyzipay
  module Model
    class RefundToBalance < IyzipayResource

      def create(request = {}, options)
        pki_string = to_pki_string(request)
        request_path = "/payment/refund-to-balance/init"
        HttpClient.post("#{options.base_url}#{request_path}", get_http_header(request_path, pki_string, options), request.to_json)
      end

      def to_pki_string(request)
        PkiBuilder.new.append_super(super).
            append(:paymentId, request[:paymentId]).
            append(:callbackUrl, request[:callbackUrl]).
            get_request_string
      end
    end
  end
end