require "rulers/version"
require "rulers/array"
require "rulers/routing"

module Rulers
  class Application
    def call(env)
      klass, act = get_controller_and_action(env) # klass為url中的第二節（class）、act就是第三節（action）
      controller = klass.new(env) # 把klass變成一個controller
      text = controller.send(act) # controller執行send的動作把我們在controller中定義的action產生的內容傳送出去
      [200, {'Content-Type' => 'text/html'},[text]]
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end
