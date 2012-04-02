require File.dirname(__FILE__) + "/base"

class ESBify::Strategy < ::ESBify::Base
  
  # TODO: There can be more then one transstatement per element, use lists for this
  
  def defaults
    {
      "main" => "",
      "expectation" => ""
    }
  end
  
  
  def xml_section(b, sect)
    b.main do |b|
      b.transStatement sect["main"]
    end
    b.expectation do |b|
      b.transStatement sect["expectation"]
    end
  end
  
  
  def to_xml
    b = Builder::XmlMarkup.new indent: 2
    b.instruct!
    b.declare! :DOCTYPE, :BehaviourSet, :SYSTEM, "esb-ji-jason/behaviours.dtd"
    b.strategy do |b|
      b << to_xml_partial
    end
  end
 
end
  
