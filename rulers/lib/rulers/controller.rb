require "erubis"
require "rulers/sqlite_model"
require "rack/request"

module Rulers
  class Controller
    include Rulers::Model
    def initialize(env)
      @env = env
    end

    def env
      @env
      @routing_params = {}
    end

    def dispatch(action, routing_params = {})
      @routing_params =routing_params
      text = self.send(action)
      if get_response
        st, hd, rs = get_response.to_a
        [st, hd, [rs.body].flatten]
      else
        [200, {"Content-Type" => "text/html"}, [text].flatten]
      end
    end

    def self.action(act, rp = {})
      proc { |e| self.new(e).dispatch(act, rp) }
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/,"")
      Rulers.to_underscore(klass)
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params.merge(@routing_params)
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end

    def redirect_to(action = "", item = nil, status = 301)
      item.nil? ? id = "" : id = item.id
      url = "http://#{@env['REMOTE_HOST']}:#{@env['SERVER_PORT']}/#{controller_name}/#{id}"
      headers = {"statustext" => "HTTP/1.1 301 Moved Permanently", "location" => url}
      @response = Rack::Response.new("", status, headers)
    end

    def render(view_name, locals = {})
      ivars = {}

      self.instance_variables.each do |i|
        ivars[i[1..-1]] = self.instance_variable_get(i)
      end

      locals = locals.merge(ivars)
      filename = File.join("app", "views",
        controller_name,
        "#{view_name}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      eruby.evaluate(locals)
    end

    def decode(string)
      attrs = []
      hash = {}
      string.split("&").each {|s| attrs.push(s)}
      attrs.map { |a| hash["#{a.split('=')[0]}"] = a.split('=')[1].to_s }
      return hash
    end
  end
end
