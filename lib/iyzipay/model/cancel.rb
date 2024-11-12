module Iyzipay
  module Model
    class Cancel < IyzipayResource

      def create(request = {}, options)
        pki_string = to_pki_string(request)
        request_path = "/payment/iyzipos/cancel"
        HttpClient.post("#{options.base_url}#{request_path}", get_http_header(request_path, pki_string, options), request.to_json)
      end

      def to_pki_string(request)
        PkiBuilder.new.append_super(super).
            append(:paymentId, request[:paymentId]).
            append(:ip, request[:ip]).
            append(:reason, request[:reason]).
            append(:description, request[:description]).
            get_request_string
      end
    end
  end
end