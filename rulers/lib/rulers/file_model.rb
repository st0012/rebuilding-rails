module Rulers
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename
        basename = File.split(filename)[-1]
        @id = File.basename(basename, "json").to_i

        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name,value)
        @hash[name.to_s] = value
      end

      def print_sentence
        submitter = @hash["submitter"]
        quote = @hash["quote"]
        return "#{quote} - #{submitter}"
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map { |f| FileModel.new f unless !FileModel.valid_json?(f) }
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id.to_i}.json")
        rescue
          return nil
        end
      end

      def self.create(attr)
        hash = {}
        hash["submitter"] = attr["submitter"] || ""
        hash["quote"] = attr["quote"] || ""
        hash["attribution"] = attr["attribution"] || ""

        files = Dir["db/quotes/*.json"]
        names = files.map { |f| f.split("/")[-1] }
        highest = names.map { |b| b.to_i }.max || 0
        id = highest + 1 

        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write <<"TEMPLATE"
{
  "id": "#{id}",
  "submitter": "#{hash["submitter"]}",
  "quote": "#{hash["quote"]}",
  "attribution": "#{hash["attribution"]}"
}
TEMPLATE
        end
        FileModel.new("db/quotes/#{id}.json")
      end

      def update(params)
        begin
          self.instance_variable_set(:@hash, params)
          return @quote
        rescue
          return false
        end
      end

      def save
        begin
          json = MultiJson.dump(@hash)
          File.write("#{@filename}",json)
        rescue
          false
        end
      end

      def destroy
        begin
          File.delete("#{@filename}")
        rescue
          false
        end
      end

      def self.valid_json?(json)
        JSON.parse File.read (json)
        return true  
      rescue JSON::ParserError
        return false  
      end
    end
  end
end