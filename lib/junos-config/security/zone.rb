module JunosConfig
  module Security
    class Zone
      attr_accessor :raw,
                    :config,
                    :name,
                    :address_book
      
      def initialize(config, raw)
        @config = config
        @raw    = raw
        @name   = raw.match(/^\ {8}security\-zone\ (\S+) \{$/)[1]      
        @address_book = raw.scan(/^(\ {12}address\-book\ \{$.*?^\ {12}\})$/m).collect do |x|
          Security::AddressBook.new self, x[0]
        end
      end
    end
  end
end
