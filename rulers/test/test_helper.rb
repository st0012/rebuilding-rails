require "rack/test"
require "test/unit"

d = File.join(File.dirname(__FILE__),"..","lib")
$LOAD_PATH.unshift File.expand_path(d)

# File.expand_path將"d"讀取到的路徑變成一絕對路徑
# $LOAD_PATH.unshift 是指把後面取得的路徑加入$LOAD_PATH中

require "rulers"