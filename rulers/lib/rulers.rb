require "rulers/version"
require "rulers/routing"
require "rulers/util.rb"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/file_model"

module Rulers
  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {"Content-Type" => "text/html"}, []]
      elsif env["PATH_INFO"] == "/"
        return [200, {"Content-Type" => "text/html"}, ["Welcome!"]]
      end
      klass, act = get_controller_and_action(env) # klass為url中的第二節（class）、act就是第三節（action）
      controller = klass.new(env) # 把klass變成一個controller
      text = controller.send(act) # controller執行send的動作把我們在controller中定義的action產生的內容傳送出去
      if controller.get_response
        st, hd, rs = controller.get_response.to_a
        [st, hd, [rs.body].flatten]
      else
        [200, {"Content-Type" => "text/html"},[text]]
      end
    end
  end
end
