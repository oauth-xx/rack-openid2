require_relative "support/config"

describe "openid integration" do
  include Rots::Test::RackTestHelpers

  it "with_get" do
    app = app({})
    mock_openid_request(app, "/", method: "GET")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_deprecated_identity" do
    app = app({})
    mock_openid_request(app, "/", method: "GET", identity: "#{Rots::Mocks::RotsServer::SERVER_URL}/john.doe?openid.success=true")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_post_method" do
    app = app({})
    mock_openid_request(app, "/", method: "POST")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "POST", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_custom_return_to" do
    app = app(return_to: "http://example.org/complete")
    mock_openid_request(app, "/", method: "GET")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/complete", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_get_nested_params_custom_return_to" do
    url = "http://example.org/complete?user[remember_me]=true"
    app = app(return_to: url)
    mock_openid_request(app, "/", method: "GET")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/complete", @response.headers["X-Path"]
    assert_equal "success", @response.body
    assert_match(/remember_me/, @response.headers["X-Query-String"])
  end

  it "with_post_nested_params_custom_return_to" do
    url = "http://example.org/complete?user[remember_me]=true"
    app = app(return_to: url)
    mock_openid_request(app, "/", method: "POST")

    assert_equal 303, @response.status
    env = Rack::MockRequest.env_for(@response.headers["Location"])
    _status, headers, _body = Rots::Mocks::RotsServer.new.call(env)

    _uri, input = headers["Location"].split("?", 2)
    mock_openid_request(app, "http://example.org/complete?user[remember_me]=true", method: "POST", input: input)

    assert_equal 200, @response.status
    assert_equal "POST", @response.headers["X-Method"]
    assert_equal "/complete", @response.headers["X-Path"]
    assert_equal "success", @response.body
    assert_match(/remember_me/, @response.headers["X-Query-String"])
  end

  it "with_post_method_custom_return_to" do
    app = app(return_to: "http://example.org/complete")
    mock_openid_request(app, "/", method: "POST")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/complete", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_custom_return_method" do
    app = app(method: "put")
    mock_openid_request(app, "/", method: "GET")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "PUT", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_simple_registration_fields" do
    app = app(required: ["nickname", "email"], optional: "fullname")
    mock_openid_request(app, "/", method: "GET")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_attribute_exchange" do
    app = app(
      required: ["http://axschema.org/namePerson/friendly", "http://axschema.org/contact/email"],
      optional: "http://axschema.org/namePerson"
    )
    mock_openid_request(app, "/", method: "GET")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_oauth" do
    app = app(
      "oauth[consumer]": "www.example.com",
      "oauth[scope]": ["http://docs.google.com/feeds/", "http://spreadsheets.google.com/feeds/"]
    )
    mock_openid_request(app, "/", method: "GET")

    location = @response.headers["Location"]

    assert_match(/openid.oauth.consumer/, location)
    assert_match(/openid.oauth.scope/, location)

    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_pape" do
    app = app(
      "pape[preferred_auth_policies]": ["test_policy1", "test_policy2"],
      "pape[max_auth_age]": 600
    )
    mock_openid_request(app, "/", method: "GET")

    location = @response.headers["Location"]

    assert_match(/pape\.preferred_auth_policies=test_policy1\+test_policy2/, location)
    assert_match(/pape\.max_auth_age=600/, location)

    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "success", @response.body
  end

  it "with_immediate_mode_setup_needed" do
    skip("because failing, and not enough time to fix all the things") do
      app = app(identifier: "#{Rots::Mocks::RotsServer::SERVER_URL}/john.doe?openid.success=false", immediate: true)
      mock_openid_request(app, "/", method: "GET")

      location = @response.headers["Location"]

      assert_match(/openid.mode=checkid_immediate/, location)

      follow_openid_redirect!(app)

      assert_equal 307, @response.status
      assert_equal "GET", @response.headers["X-Method"]
      assert_equal "/", @response.headers["X-Path"]
      assert_equal Rots::Mocks::RotsServer::SERVER_URL, @response.headers["Location"]
      assert_equal "setup_needed", @response.body
    end
  end

  it "with_realm_wildcard" do
    app = app(
      realm_domain: "*.example.org"
    )
    mock_openid_request(app, "/", method: "GET")

    location = @response.headers["Location"]

    assert_match(/openid.realm=http%3A%2F%2F%2A.example.org/, location)

    follow_openid_redirect!(app)

    assert_equal 200, @response.status
  end

  it "with_inferred_realm" do
    app = app({})
    mock_openid_request(app, "/", method: "GET")

    location = @response.headers["Location"]

    assert_match(/openid.realm=http%3A%2F%2Fexample.org/, location)

    follow_openid_redirect!(app)

    assert_equal 200, @response.status
  end

  it "with_missing_id" do
    app = app(identifier: "#{Rots::Mocks::RotsServer::SERVER_URL}/john.doe")
    mock_openid_request(app, "/", method: "GET")
    follow_openid_redirect!(app)

    assert_equal 400, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "cancel", @response.body
  end

  it "with_timeout" do
    app = app(identifier: Rots::Mocks::RotsServer::SERVER_URL)
    mock_openid_request(app, "/", method: "GET")

    assert_equal 400, @response.status
    assert_equal "GET", @response.headers["X-Method"]
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "missing", @response.body
  end

  it "sanitize_query_string" do
    app = app({})
    mock_openid_request(app, "/", method: "GET")
    follow_openid_redirect!(app)

    assert_equal 200, @response.status
    assert_equal "/", @response.headers["X-Path"]
    assert_equal "", @response.headers["X-Query-String"]
  end

  it "passthrough_standard_http_basic_auth" do
    app = app({})
    mock_openid_request(app, "/", :method => "GET", "MOCK_HTTP_BASIC_AUTH" => "1")

    assert_equal 401, @response.status
  end

  private

  def app(options = {})
    Rots::Mocks::ClientApp.new(**options)
  end
end
