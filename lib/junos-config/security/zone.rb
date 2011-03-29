module JunosConfig
  module Security
    class Zone
      attr_accessor :config,
                    :name
      
      def initialize(config)
        @config = config
        @name   = config.match(/^\ {8}security\-zone\ (\w+) \{$/)[1]
      end
    end
  end
end
