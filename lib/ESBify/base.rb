require "builder"
class ESBify::Base
  def initialize
    @data = []
  end

  def defaults
    
  end

  def <<(sects)
    @data += sects.map do |sect|
      defaults.merge(sect)
    end
  end

  def to_xml_partial
    b = Builder::XmlMarkup.new indent: 2, margin: 1
    @data.each do |sect|
      xml_section(b, sect)
    end
    #puts b.inspect
    "\n" + b.target!
  end  
  
  
end