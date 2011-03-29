module JunosConfig
  class Interface
    attr_accessor :config,
                  :name
    
    def initialize(config)
      @config = config
      @name   = config.match(/^\ {4}(\S+)\ \{$/)[1]
    end
  end
end
