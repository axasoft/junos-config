module JunosConfig
  class Config
    attr_reader :config,
                :interfaces
    
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
  end
end
