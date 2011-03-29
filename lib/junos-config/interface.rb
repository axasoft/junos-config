module JunosConfig
  class Interface
    attr_accessor :raw,
                  :config,
                  :name
    
    def initialize(config, raw)
      @config = config
      @raw    = raw
      @name   = raw.match(/^\ {4}(\S+)\ \{$/)[1]
    end
  end
end
