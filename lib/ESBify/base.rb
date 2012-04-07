require "builder"
class ESBify::Base
  def initialize
    @data = []
  end

  def defaults
    
  end
  
  def keys
    defaults.keys.join("|")
  end
  
  def parse!(str)
    segs = str.split(/\s*\n---+\s*\n\s*/m)
    @data += segs.map do |seg|
      ms = seg.scan /(?:^|\n)(#{keys})\s*\:\s*(.+?)(?=(?:\n(?:#{keys})\s*\:|\z))/m
      if m1 = seg.strip.match(/(?:^)(?!#{keys})(\w+)\s*\:\s*\n/)
        ms << ["name", m1[1]]
      end
      defaults.merge Hash[*ms.flatten.map(&:strip)]
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