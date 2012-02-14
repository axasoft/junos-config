module JunosConfig
  class Config
    attr_reader :raw,
                :last_changed,
                :version,
                :hostname,
                :interfaces,
                :security_zones,
                :security_policies,
                :applications,
                :application_sets
    
    def initialize(raw)
      @raw = raw
    
      m = raw.match(/Last\ changed:\ (.*?)\nversion\ (\S+);/m)
      @last_changed = m[1] if m
      @version = m[2] if m
      
      raw.scan(/^(\w+)\ \{$(.*?)^\}$/m).each do |section|
        method = "parse_#{section[0]}"
        send method, section[1] if respond_to?(method)
      end
    end
    
    def parse_groups(raw_section)
      m = raw_section.match(/host\-name\ (\S+)-\S;/m)
      @hostname = m[1]
    end
    
    def parse_interfaces(raw_section)
      @interfaces = raw_section.scan(/^(\ {4}\S+\ \{$.*?^\ {4}\})$/m).collect do |x|
        Interface.new self, x[0]
      end
    end
    
    def parse_security(raw_section)
      @security_zones = raw_section.scan(/^(\ {8}security\-zone\ \S+ \{$.*?^\ {8}\})$/m).collect do |x|
        Security::Zone.new self, x[0]
      end
      @security_policies = raw_section.scan(/^\ {8}from\-zone\ (\S+) to\-zone (\S+) \{$(.*?)^\ {8}\}$/m).collect do |x|
        from_zone = security_zones.find{ |zone| zone.name == x[0] }
        to_zone   = security_zones.find{ |zone| zone.name == x[1] }
        x[2].scan(/(\ {12}policy \S+ \{$.*?^\ {12}\}$)/m).collect do |y|
          Security::Policy.new self, y[0], from_zone, to_zone
        end
      end
      @security_policies.flatten!
    end
    
    def parse_applications(raw_section)
      @applications = raw_section.scan(/^(\ {4}application\ \S+ \{$.*?^\ {4}\})$/m).collect do |x|
        Application.new self, x[0]
      end
      @application_lookup = {}
      @applications.each{|a| @application_lookup[a.name] =  a }
      @application_sets = raw_section.scan(/^(\ {4}application\-set\ \S+ \{$.*?^\ {4}\})$/m).collect do |x|
        ApplicationSet.new self, x[0]
      end
      @application_sets.each{|a| @application_lookup[a.name] =  a }
      
      @security_policies.each do |policy|
        policy.application.collect! {|name| application(name) }
      end
    end
    
    def application(name)
      if name =~ /any|ESP|esp|junos\-/
        # junos internal applications
        return name
      end
      @application_lookup[name]
    end
  end
end
