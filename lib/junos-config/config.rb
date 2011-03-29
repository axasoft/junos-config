module JunosConfig
  class Config
    attr_reader :config,
                :interfaces,
                :security_zones,
                :security_policies
    
    def initialize(config)
      @config = config
      config.scan(/^(\w+)\ \{$(.*?)^\}$/m).each do |section|
        method = "parse_#{section[0]}"
        send method, section[1] if respond_to?(method)
      end
    end
    
    def parse_interfaces(raw)
      @interfaces = raw.scan(/^(\ {4}\S+\ \{$.*?^\ {4}\})$/m).collect do |section|
        Interface.new section[0]
      end
    end
    
    def parse_security(raw)
      @security_zones = raw.scan(/^(\ {8}security\-zone\ \w+ \{$.*?^\ {8}\})$/m).collect do |section|
        Security::Zone.new section[0]
      end
    end
  end
end
