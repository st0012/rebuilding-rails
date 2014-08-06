require "erubis"
require "rulers/file_model"

module Rulers
  class Controller
    include Rulers::Model
    def initialize(env)
      @env = env
    end

    def env
      @env
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
      request.params
    end

    def response(text, status = 200, headers = {})
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render_response(*args)
      response(render(*args))
    end

    def redirect_to(action = "", item = {}, status = 301, text = "123")
      if action == :show
        action = "show?id=#{item['id']}"
      end
      url = "http://#{@env['REMOTE_HOST']}:#{@env['SERVER_PORT']}/#{controller_name}/#{action}"
      headers = {"statustext" => "HTTP/1.1 301 Moved Permanently", "location" => url}
      @response = Rack::Response.new(text, status, headers)
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
