module JunosConfig
  module Security
    class AddressSet
      attr_accessor :raw,
                    :config,
                    :name,
                    :addresses
    
      def initialize(config, raw)
        @config = config
        @raw    = raw
        @name   = raw.match(/^\ {16}address-set (\S+)\ \{$/)[1]
        @addresses = raw.scan(/^(\ {20}address (\S+);)$/).collect do |x|
          String.new x[1]
        end
      end
      
      def lookup_addresses( addressbook )
        @addresses.collect! do |addr|
          addressbook.resolve(addr)
        end
      end
    end
  end
end
