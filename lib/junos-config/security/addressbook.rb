module JunosConfig
  module Security
    class AddressBook
      attr_accessor :raw,
                    :config,
                    :name,
                    :addresses,
                    :address_sets
    
      def initialize(config, raw)
        @config = config
        @raw    = raw        
        @addresses = raw.scan(/^(\ {16}address \S+ \S+;)$/).collect do |x|
          Security::Address.new self, x[0]
        end
        @address_sets = raw.scan(/^(\ {16}address-set \S+ \{$.*?^\ {16}\})$/m).collect do |x|
          Security::AddressSet.new self, x[0]
        end
        @resolv = {}
        @addresses.each { |a| @resolv[a.name] = a }
        @address_sets.each do |as|
          @resolv[as.name] = as
          aset = as.lookup_addresses(self)
          aset.each{ |a| @resolv[a.name] = a }
        end
      end
      
      def resolve(name)
        @resolv[name]
      end

      def lookup(name)
        addrs = resolve(name)
        return unless addrs
        return addrs.addresses if addrs.class == JunosConfig::Security::AddressSet
        [addrs]
      end
    end
  end
end
