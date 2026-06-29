require_relative "support/config"

describe Rack::OpenID do
  describe ".sanitize_params!" do
    def call(*args)
      Rack::OpenID.new(nil, nil).send(:sanitize_params!, *args)
    end

    # https://github.com/openid/ruby-openid/pull/54
    it "stops the base64 encoded nonce and sig from having its +'s transformed into spaces by Rack::Request" do
      params = {
        "openid.sig" => "a string with spaces",
        "openid.response_nonce" => "again with spaces!"
      }

      call(params)

      _(params["openid.sig"]).must_equal("a+string+with+spaces")
      _(params["openid.response_nonce"]).must_equal("again+with+spaces!")
    end
  end
end
