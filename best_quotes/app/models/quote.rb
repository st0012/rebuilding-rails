require "sqlite3"
require "rulers/sqlite_model"
 
class Quote < Rulers::Model::SQLite
  
end

# STDERR.puts Quote.schema.keys
# puts "Count: #{Quote.count}"

# obj = Quote.new("id" => 3)
# Quote.create("id"=>1,"quote"=>"bla")
# puts Quote.all
# puts Quote.find(1)
