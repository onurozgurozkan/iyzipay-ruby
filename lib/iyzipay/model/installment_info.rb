module Iyzipay
  module Model
    class InstallmentInfo < IyzipayResource

      def retrieve(request = {}, options)
        pki_string = to_pki_string(request)
        request_path = "/payment/iyzipos/installment"
        HttpClient.post("#{options.base_url}#{request_path}", get_http_header(request_path, pki_string, options), request.to_json)
      end

      def to_pki_string(request)
        PkiBuilder.new.append_super(super).
            append(:binNumber, request[:binNumber]).
            append_price(:price, request[:price]).
            get_request_string
      end
    end
  end
end