require "sqlite3"
require "rulers/util"
DB = SQLite3::Database.new "test.db"
module Rulers
  module Model
    class SQLite
      def initialize(data = nil)
        @hash = data
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.to_sql(val)
        case val
        when Numeric
          val.to_s
        when String
          "'#{val}'"
        else
          raise "Can't change #{val.class} to SQL"
        end
      end

      def self.all
        rows = DB.execute <<SQL
select #{schema.keys.join(",")} from #{table}
SQL
        datas = rows.inject([]) do |array, row|
          array << self.new(Hash[schema.keys.zip(row)])
        end
      end

      def self.find(id)
        row = DB.execute <<SQL
select #{schema.keys.join(",")} from #{table} where id = #{id}
SQL
        data = Hash[schema.keys.zip(row[0])]
        self.new(data)
      end

      def self.create(values)
        values.delete("id")
        keys = schema.keys - ["id"]

        vals = keys.map do |key|
          values[key] ? to_sql(values[key]) : 
          "null"
        end

        DB.execute <<SQL
INSERT INTO #{table} (#{keys.join(",")})
  VALUES (#{vals.join(",")});
SQL
        data = Hash[keys.zip(vals)]
        sql = "SELECT last_insert_rowid();"
        data["id"] = DB.execute(sql)[0][0]
        self.new(data)
      end

      def update(params)
        begin
          self.instance_variable_set(:@hash, params)
          return @quote
        rescue
          return false
        end
      end

      def save!
        unless @hash["id"] #if id is nil
          self.class.create
          return true
        end

        unvalid = @hash.keys - self.class.schema.keys
        unvalid.each { |key| @hash.delete(key) }
        
        fields = @hash.map do |key, value|
          "#{key}=#{self.class.to_sql(value)}"
        end.join(",")

        puts @hash.to_s, fields
        DB.execute <<SQL
UPDATE #{self.class.table}
SET #{fields}
WHERE id = #{@hash["id"]}
SQL
        true
      end

      def save
        self.save! rescue false
      end

      def self.count
        DB.execute(<<SQL)[0][0]
SELECT COUNT(*) FROM #{table}
SQL
      end

      def destroy
        DB.execute <<SQL
DELETE FROM #{self.class.table}
WHERE id = #{@hash["id"]}
SQL
        rescue false
      end

      def self.table
        Rulers.to_underscore(name)
      end

      def self.schema
        return @schema if @schema
        @schema = {}

        DB.table_info(table) do |row|
          @schema[row["name"]] = row["type"]
        end
        # @schema.keys.each do |method|
        #   define_method(method){
        #     self["#{method}"]
        #   }
        # end
        @schema
      end

      def method_missing(sym, *args, &block)
        self["#{sym}"]
      end

      def print_sentence
        submitter = @hash["submitter"]
        quote = @hash["quote"]
        return "#{quote} - #{submitter}"
      end
    end
  end
end
