module JunosConfig
  class Interface
    attr_accessor :raw,
                  :config,
                  :name
    
    def initialize(raw, config)
      @raw    = raw
      @config = config
      @name   = raw.match(/^\ {4}(\S+)\ \{$/)[1]
    end
  end
end
