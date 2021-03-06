require 'mechanize'

module Stores
  class Base
    def initialize(model)
      @name = model.name
      @base_url = model.base_url
      @model = model
      @agent = Mechanize.new
    end

    def get(url, params={})
      @agent.get("#{@base_url}/#{url}", params)
    end

    def post(url, params={})
      @agent.post("#{@base_url}/#{url}", params)
    end

    # def self.element(name, pattern)
    #   define_method("#{name}_finder".to_sym) {|el| el.search(pattern) }
    # end
  end
end
