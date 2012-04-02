require File.dirname(__FILE__) + "/base"

class ESBify::Behavior < ::ESBify::Base
  
  def defaults
    {
      "name" => rand(1000),
      "ctl" => "",
      "jason" => "",
      "action" => "",
    }
  end
  
  
  def xml_section(b, sect)
    b.behaviour name: sect["name"] do |b|
      b.condition do |b|
        b.ctl sect["ctl"]
        b.jason sect["jason"]
      end
      b.action sect["action"]
    end 
  end
  
  
  def to_xml
    b = Builder::XmlMarkup.new indent: 2
    b.instruct!
    b.declare! :DOCTYPE, :BehaviourSet, :SYSTEM, "esb-ji-jason/behaviours.dtd"
    b.BehaviourSet do |b|
      b << to_xml_partial
    end # ExpectationSet
  end
 
end
  
