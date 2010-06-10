module DefiniteArticleHelper
  def the
    @the ||= DefiniteArticle.new
  end

  class DefiniteArticle
    def initialize
      @data = {}
    end

    def method_missing(method_name, value=nil)
      if method_name.to_s =~ /(.*)=$/
        @data[$1.to_sym] = value
      else
        @data[method_name]
      end
    end
  end
end
