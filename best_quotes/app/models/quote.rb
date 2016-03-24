require "sqlite3"
require "rulers/sqlite_model"
 
class Quote < Rulers::Model::SQLite
  self.schema.keys.each do |method|
    define_method(method){
      self["#{method}"]
    }
  end
end
