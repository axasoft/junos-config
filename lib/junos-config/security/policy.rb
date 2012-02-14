module JunosConfig
  module Security
    class Policy
      attr_accessor :raw,
                    :config,
                    :name,
                    :from_zone,
                    :to_zone,
                    :source_address,
                    :destination_address,
                    :application
      
      def initialize(config, raw, from_zone, to_zone)
        @config    = config
        @raw       = raw
        @from_zone = from_zone
        @to_zone   = to_zone
        @name      = raw.match(/^\ {12}policy (\S+)\ \{$/)[1]
        
        raw.scan(/^\ {20}source\-address\ ([^;]+);/).each do |src|
          s = src[0].split(" ")
          s = s.slice(1,s.length-2) if s.length > 1
          @source_address =  s
        end
        raw.scan(/^\ {20}destination\-address\ ([^;]+);/).each do |dst|
          s = dst[0].split(" ")
          s = s.slice(1,s.length-2) if s.length > 1
          @destination_address = s
        end
        raw.scan(/^\ {20}application\ ([^;]+);/).each do |app|
          s = app[0].split(" ")
          s = s.slice(1,s.length-2) if s.length > 1
          @application = s
        end
      end
    end
  end
end
