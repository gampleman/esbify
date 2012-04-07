require File.dirname(__FILE__) + "/base"
module ESBify
  class Expectation < ::ESBify::Base
    attr_reader :names
    
    def defaults
      {
        "agent" => "self",
        "name" => rand(1000),
        "condition" => "true",
        "phi" => "",
        "test_plus" => "",
        "test_minus" => "",
        "rho_plus" => {
          "addSet" => [],
          "remSet" => []
        },
        "rho_minus" => {
          "addSet" => [],
          "remSet" => []
        }
      }
    end
    
    def parse!(str)
      @names ||= []
      segs = str.split(/\s*\n---+\s*\n\s*/m)
      @data += segs.map do |seg|
        ms = seg.scan /(?:^|\n)(#{keys})\s*\:\s*(.+?)(?=(?:\n(?:#{keys})\s*\:|\z))/m
        if m1 = seg.strip.match(/(?:^)(?!#{keys})(\w+)\s*\:\s*\n/)
          ms << ["name", m1[1]]
        end
        
        sect = Hash[*ms.flatten.map(&:strip)]
        
        if sect["rho_plus"]
          sect["rho_plus"] = parse_mods(sect["rho_plus"])
        elsif sect["test_plus"]
          sect["rho_plus"] = parse_mods(sect["test_plus"])
          sect["test_plus"] = sect["test_plus"].split(/^\s*(\+|\-)/).first.strip
        end
        
        if sect["rho_minus"]
          sect["rho_minus"] = parse_mods(sect["rho_minus"])
        elsif sect["test_minus"]
          sect["rho_minus"] = parse_mods(sect["test_minus"])
          sect["test_minus"] = sect["test_minus"].split(/^\s*(\+|\-)/).first.strip
        end
        
        @names << sect["name"] if sect["name"]
        defaults.merge sect
      end

    end

    
    def parse_mods(str)
      add_set = []
      rem_set = []
      str.scan(/^\s*(\+|\-)\s*(.+)\s*$/).each do |sym, str|
        if sym == "+"
          add_set << str
        else
          rem_set << str
        end
      end
      {"addSet" => add_set, "remSet" => rem_set}
    end
    
    def to_xml
      b = Builder::XmlMarkup.new indent: 2
      b.instruct!
      b.declare! :DOCTYPE, :ExpectationSet, :SYSTEM, "esb-ji-jason/ExpectationSet.dtd"
      b.ExpectationSet do |b|
        b << to_xml_partial
      end # ExpectationSet
    end
   
    def xml_section(b, sect)
      b.tag! "expectation" do |b|
        sect.each do |k,v|
          if v.is_a?(Array) || v.is_a?(Hash)
            b.tag! k do |b|
              b.tag! "addSet" do |b|
                v["addSet"].each {|el| b.name(el) }
              end
              b.tag! "remSet" do |b|
                v["remSet"].each {|el| b.name(el) }
              end
            end 
          else
            b.tag! k, v
          end
        end
      end # base
    end
   
   
  end
  
end