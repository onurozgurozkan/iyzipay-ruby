module Iyzipay
  module Model
    class CheckoutFormInitialize < IyzipayResource

      def create(request = {}, options)
        pki_string = to_pki_string(request)
        request_path = "/payment/iyzipos/checkoutform/initialize/ecom"
        HttpClient.post("#{options.base_url}#{request_path}", get_http_header(request_path, pki_string, options), request.to_json)
      end

      def to_pki_string(request)
        PkiBuilder.new.append_super(super).
            append_price(:price, request[:price]).
            append(:basketId, request[:basketId]).
            append(:paymentGroup, request[:paymentGroup]).
            append(:buyer, Buyer.to_pki_string(request[:buyer])).
            append(:shippingAddress, Address.to_pki_string(request[:shippingAddress])).
            append(:billingAddress, Address.to_pki_string(request[:billingAddress])).
            append_array(:basketItems, Basket.to_pki_string(request[:basketItems])).
            append(:callbackUrl, request[:callbackUrl]).
            append(:paymentSource, request[:paymentSource]).
            append(:currency, request[:currency]).
            append(:posOrderId, request[:posOrderId]).
            append_price(:paidPrice, request[:paidPrice]).
            append(:forceThreeDS, request[:forceThreeDS]).
            append(:cardUserKey, request[:cardUserKey]).
            append_array(:enabledInstallments, request[:enabledInstallments]).
            get_request_string
      end
    end
  end
end