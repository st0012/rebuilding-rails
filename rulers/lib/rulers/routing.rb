class RouteObject
  def initialize
    @rules = []
  end

  def resources(resource)
    index  =  { :method => "GET",  :regexp => /^\/(#{resource})\/$/, :vars => ["controller"], :options => { :default => { "action" => "index" }}}
    show   =  { :method => "GET",  :regexp => /^\/(#{resource})\/([0-9]+)$/, :vars => ["controller", "id"], :options => {:default=>{ "action" => "show" }}}
    new    =  { :method => "GET",  :regexp => /^\/(#{resource})\/([a-z]+)$/, :vars => ["controller", "action"], :options => {:default=>{}}}
    edit   =  { :method => "GET",  :regexp => /^\/(#{resource})\/([0-9]+)\/([a-z]+)$/, :vars => ["controller", "id", "action"], :options => {:default=>{}}}
    create =  { :method => "POST", :regexp => /^\/(#{resource})\/([a-z]+)$/, :vars => ["controller", "action"], :options => {:default=>{}}}
    update =  { :method => "PUT", :regexp => /^\/(#{resource})\/([0-9]+)\/([a-z]+)$/, :vars => ["controller", "id", "action"], :options => {:default=>{}}}
    delete =  { :method => "DELETE", :regexp => /^\/(#{resource})\/([0-9]+)\/([a-z]+)$/, :vars => ["controller", "id", "action"], :options => {:default=>{}}}
    
    @rules << new << show << index << edit << create << update << delete
  end

  def match(url, *args)
    options = {}
    options = args.pop if args[-1].is_a?(Hash) #如果最後一個argument為hash則取出他為option 
    options[:default] ||= {}

    dest = nil
    dest = args.pop if args.size > 0

    raise "Too many args!!" if args.size > 0

    parts = url.split("/")
    parts.select! { |p| !p.empty? }

    vars = []
    regexp_parts = parts.map do |part|
      if part[0] == ":"
        vars << part[1..-1]
        "([a-zA-Z0-9]+)"
      elsif part[0] == "*"
        vars << part[1..-1]
        "(.*)"
      else
        part
      end
    end

    regexp = regexp_parts.join("/")
    @rules.push({
      :regexp => Regexp.new("^/#{regexp}$"),
      :vars => vars,
      :dest => dest,
      :options => options,
      :method => "GET"
    })
  end

  def check_url(url, method)
    puts "method is #{method}"
    @rules.each do |r|
      if r[:method] == method
        m = r[:regexp].match(url)
        puts "#{m} ++++ #{r}"
        if m
          options = r[:options]
          params = options[:default].dup

          r[:vars].each_with_index do |v, i|
            puts "#{v} == #{m.captures[i]}"
            params[v] = m.captures[i]
          end

          dest = nil
          if r[:dest]
            return get_dest(r[:dest], params)
          else
            controller = params["controller"]
            action = params["action"]
            return get_dest("#{controller}" + "##{action}", params)
          end
        end
      end
    end
    raise "No match!"
  end

  def get_dest(dest, routing_params = {})
    return dest if dest.respond_to?(:call)
    if dest =~/^([^#]+)#([^#]+)$/
      name = $1.capitalize
      cont = Object.const_get("#{name}Controller")
      return cont.action($2, routing_params)
    end
    raise "No destination: #{dest.inspect}!"
  end
end

module Rulers
  class Application
    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
    end

    def get_rack_app(env)
      raise "No routes!" unless @route_obj
      @route_obj.check_url(env["PATH_INFO"], env["REQUEST_METHOD"])   
    end

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