module Iyzipay
  module Model
    class SettlementToBalance < IyzipayResource

      def create(request = {}, options)
        pki_string = to_pki_string(request)
        request_path = "/payment/settlement-to-balance/init"
        HttpClient.post("#{options.base_url}#{request_path}", get_http_header(request_path, pki_string, options), request.to_json)
      end

      def to_pki_string(request)
        PkiBuilder.new.append_super(super).
            append(:subMerchantKey, request[:subMerchantKey]).
            append(:callbackUrl, request[:callbackUrl]).
            append_price(:price, request[:price]).
            get_request_string
      end
    end
  end
end
