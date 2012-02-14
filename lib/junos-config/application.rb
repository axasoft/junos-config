module JunosConfig
  class Application
    attr_accessor :raw,
                  :config,
                  :name
    
    def initialize(config, raw)
      @config = config
      @raw    = raw
      @name   = raw.match(/^\ {4}application (\S+)\ \{$/)[1]
    end
    
    def to_s
      @name
    end
    
    def list_of_objects
      [self]
    end
    
    def details
      "#{name}: #{raw}"
    end
    
  end

  class ApplicationSet
    attr_accessor :raw,
                  :config,
                  :name,
                  :applications
    
    def initialize(config, raw)
      @config = config
      @raw    = raw
      @name   = raw.match(/^\ {4}application\-set (\S+)\ \{$/)[1]
      @applications = raw.scan(/^(\ {8}application (\S+);)$/).collect do |x|
        config.application(x[1])
      end
    end
    
    def to_s
      @name
    end    
    
    def list_of_objects
      applications
    end
    
  end

end

class String
  
  def list_of_objects
    [self]
  end
  
  def details
    to_s
  end
end
