module JunosConfig
  module Security
    class Policy
      attr_accessor :raw,
                    :config,
                    :name,
                    :from_zone,
                    :to_zone
      
      def initialize(config, raw, from_zone, to_zone)
        @config    = config
        @raw       = raw
        @from_zone = from_zone
        @to_zone   = to_zone
        @name      = raw.match(/^\ {12}policy (\S+)\ \{$/)[1]
      end
    end
  end
end
