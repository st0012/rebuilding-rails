module Rulers
  class Application
    def get_controller_and_action(env)
      # 拆網址
      _, cont, action, after = 
        env["PATH_INFO"].split('/',4) # 把env(也就是url)拆成四個部分，這邊取第二節（class）、第三節（action）
      cont = cont.capitalize # "Quotes"
      cont += "Controller" # "QuotesController"

      # 回傳網址中間的class跟action
      [Object.const_get(cont), action] # const_get是把字串轉為class
    end
  end
end