module JunosConfig
  module Security
    class Zone
      attr_accessor :raw,
                    :config,
                    :name
      
      def initialize(config, raw)
        @config = config
        @raw    = raw
        @name   = raw.match(/^\ {8}security\-zone\ (\S+) \{$/)[1]
      end
    end
  end
end
