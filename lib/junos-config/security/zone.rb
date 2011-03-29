module JunosConfig
  module Security
    class Zone
      attr_accessor :raw,
                    :config,
                    :name
      
      def initialize(raw, config)
        @raw    = raw
        @config = config
        @name   = raw.match(/^\ {8}security\-zone\ (\w+) \{$/)[1]
      end
    end
  end
end
