require 'erubis'
require File.dirname(__FILE__) + "/expectation"
require File.dirname(__FILE__) + "/behavior"
#require "./behavior"
#require "./strategy"

class ESBify::Parser
  
  attr_reader :expectation
  
  def initialize(context = {})
    @expectation = ::ESBify::Expectation.new
    @behavior = ::ESBify::Behavior.new
    #@strategy = ::ESBify::Strategy.new
    
    @context = context
  end
  
  
  def expectations
    @expectation.to_xml
  end
  
  def behaviors
    @behavior.to_xml
  end
  
  def strategies
    @strategy.to_xml
  end
  
  def parse_file!(path)
    parse! File.read(path)
  end
  
  def parse!(str)
    # Remove comments
    str = str.split("\n").map{|l| l.split('#').first }.join("\n")
    str = Erubis::Eruby.new(str).evaluate(@context)
    str.split(/\!(?=(?:expectation|behaviou?r|strateg(?:y|ie))s?\n)/).each do |section|
      next if section =~ /\A\s*\z/m
      m = section.match /\A(expectation|behaviou?r|strateg(?:y|ie))s?/
      txt = str.split("\n")
      txt.shift
      txt.join("\n")
      sect = parse_section(section)
      case m[1]
      when /expectations?/
        @expectation << sect
      when /behaviou?rs?/
        @behavior << sect
      when /strateg(?:y|ie)s?/
        @strategy << sect
      else
        raise ArgumentError
      end
    end
    
  end
  
  
  def parse_section(str)
    segs = str.split(/\s*\n---+\s*\n\s*/m)
    segs.map do |seg|
      ms = seg.scan /(?:^|\n)([\w_]+)\s*\:\s*(.+?)(?=(?:\n[\w_]+\s*\:|\z))/m
      Hash[*ms.flatten.map(&:strip)]
    end
  end
end