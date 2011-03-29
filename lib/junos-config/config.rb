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
        Interface.new self, x[0]
      end
    end
    
    def parse_security(raw_section)
      @security_zones = raw_section.scan(/^(\ {8}security\-zone\ \S+ \{$.*?^\ {8}\})$/m).collect do |x|
        Security::Zone.new self, x[0]
      end
      @security_policies = raw_section.scan(/^\ {8}from\-zone\ (\S+) to\-zone (\S+) \{$(.*?)^\ {8}\}$/m).collect do |x|
        from_zone = security_zones.find{ |zone| zone.name == x[0] }
        to_zone   = security_zones.find{ |zone| zone.name == x[1] }
        x[2].scan(/(\ {12}policy \S+ \{$.*?^\ {12}\}$)/m).collect do |y|
          Security::Policy.new self, y[0], from_zone, to_zone
        end
      end
      @security_policies.flatten!
    end
  end
end
