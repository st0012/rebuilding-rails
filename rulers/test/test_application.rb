require_relative "test_helper"

class TestController < Rulers::Controller
  def index
    render :index, text: "Hello!"
  end
  
  def render(view_name, locals = {})
    filename = File.join "test", "app", "views",
      controller_name,
      "#{view_name}.html.erb"
    template = File.read filename
    eruby = Erubis::Eruby.new(template)
    eruby.result locals.merge(env: env)
  end
end

class TestApp < Rulers::Application
  
end

class RulerAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "test/index"
    assert last_response.ok?
    body = last_response.body
    assert body["Hello!"]
  end
end