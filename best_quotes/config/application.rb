require "rulers"

module BestQuotes
  class Application < Rulers::Application

  end
end

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "app", "models")
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "app", "controllers")

# Filr.dirname(__FILE__) 取得當前文件路徑
# File.join("..", "app", "controllers") == ../app/controller == 從config離開到app/controllers去抓檔案
# $LOAD_PATH.unshift 是指把後面取得的路徑加入$LOAD_PATH中
