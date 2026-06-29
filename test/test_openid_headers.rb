require_relative "support/config"

describe "openid headers" do
  it "builds header" do
    assert_equal 'OpenID identity="http://example.com/"',
      Rack::OpenID.build_header(identity: "http://example.com/")
    assert_equal 'OpenID identity="http://example.com/?foo=bar"',
      Rack::OpenID.build_header(identity: "http://example.com/?foo=bar")

    header = Rack::OpenID.build_header(identity: "http://example.com/", return_to: "http://example.org/")

    assert_match(/OpenID /, header)
    assert_match(/identity="http:\/\/example\.com\/"/, header)
    assert_match(/return_to="http:\/\/example\.org\/"/, header)

    header = Rack::OpenID.build_header(identity: "http://example.com/", required: ["nickname", "email"])

    assert_match(/OpenID /, header)
    assert_match(/identity="http:\/\/example\.com\/"/, header)
    assert_match(/required="nickname,email"/, header)
  end

  it "parses header" do
    assert_equal(
      {"identity" => "http://example.com/"},
      Rack::OpenID.parse_header('OpenID identity="http://example.com/"')
    )
    assert_equal(
      {"identity" => "http://example.com/?foo=bar"},
      Rack::OpenID.parse_header('OpenID identity="http://example.com/?foo=bar"')
    )
    assert_equal(
      {"identity" => "http://example.com/", "return_to" => "http://example.org/"},
      Rack::OpenID.parse_header('OpenID identity="http://example.com/", return_to="http://example.org/"')
    )
    assert_equal(
      {"identity" => "http://example.com/", "required" => ["nickname", "email"]},
      Rack::OpenID.parse_header('OpenID identity="http://example.com/", required="nickname,email"')
    )

    # ensure we don't break standard HTTP basic auth
    assert_empty(
      Rack::OpenID.parse_header('Realm="Example"')
    )
  end
end
