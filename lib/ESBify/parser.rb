require 'erubis'
require File.dirname(__FILE__) + "/expectation"
require File.dirname(__FILE__) + "/behavior"
require File.dirname(__FILE__) + "/strategy"


# The Parser is the top level class. It's responsibility it is to do most of the generic processing of
# the language and then delegate to the Strategy, Behavior and Expectation classes.
#
# Usage:
#
#    parser = ESBify::Parser.new
#    parser.parse_file! "path/to/file.esb"
#    puts parser.expectations #=> "<?xml ..."
class ESBify::Parser
  
  attr_reader :expectation
  
  def initialize(context = {})
    @expectation = ::ESBify::Expectation.new
    @behavior = ::ESBify::Behavior.new
    @strategy = ::ESBify::Strategy.new
    
    @context = context
  end
  
  # After parsing contains the xml representation of all expectations.
  def expectations
    @expectation.to_xml
  end
  
  # After parsing contains the xml representation of all behaviors.
  def behaviors
    @behavior.to_xml
  end
  
  # After parsing contains the xml representation of the strategy.
  def strategies
    @strategy.to_xml
  end
  alias_method :strategy, :strategies
  
  # Pass a file path. File will be read and parsed.
  def parse_file!(path)
    parse! File.read(path)
  end
  
  # Parse a string of esb code.
  def parse!(str)
    # Remove comments
    str = str.split("\n").map{|l| l.split('#').first }.join("\n")
    # Evaluate ERB code
    str = Erubis::Eruby.new(str).evaluate(@context)
    # Split by sections
    str.split(/\!(?=(?:expectation|behaviou?r|strateg(?:y|ie))s?\n)/).each do |section|
      next if section =~ /\A\s*\z/m
      m = section.match /\A(expectation|behaviou?r|strateg(?:y|ie))s?/
      txt = str.split("\n")
      txt.shift
      txt.join("\n")
      case m[1]
      when /expectations?/
        @expectation.parse! section
      when /behaviou?rs?/
        @behavior.parse! section
      when /strateg(?:y|ie)s?/
        @strategy.parse! section
      else
        raise ArgumentError
      end
    end
    
  end
  
end