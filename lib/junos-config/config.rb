module JunosConfig
  class Config
    attr_reader :raw,
                :interfaces,
                :security_zones,
                :security_policies
    
    def initialize(raw)
      @raw = raw
      raw.scan(/^(\w+)\ \{$(.*?)^\}$/m).each do |section|
        method = "parse_#{section[0]}"
        send method, section[1] if respond_to?(method)
      end
    end
    
    def parse_interfaces(raw_section)
      @interfaces = raw_section.scan(/^(\ {4}\S+\ \{$.*?^\ {4}\})$/m).collect do |x|
        Interface.new x[0], self
      end
    end
    
    def parse_security(raw_section)
      @security_zones = raw_section.scan(/^(\ {8}security\-zone\ \w+ \{$.*?^\ {8}\})$/m).collect do |x|
        Security::Zone.new x[0], self
      end
    end
  end
end
