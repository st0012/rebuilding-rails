require "erubis"

module Rulers
  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def render(view_name, locals = {})
      filename = File.join("app", "views",
        controller_name,
        "#{view_name}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      eruby.evaluate(locals.merge(env: env))
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/,"")
      puts self.class.to_s.gsub(/Controller$/,"")
      Rulers.to_underscore(klass)
    end
  end
end
