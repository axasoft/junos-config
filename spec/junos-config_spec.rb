ROOT = File.expand_path(File.dirname(__FILE__))
require File.join(ROOT, 'spec_helper')
SAMPLE_1 = File.read(File.join(ROOT, 'sample_configs', 'sample_1')).freeze

describe JunosConfig do
  describe Config do
    describe 'initialized with sample config 1' do
      before :each do
        @config = JunosConfig::Config.new SAMPLE_1
      end
      
      it 'should have 9 interfaces' do
        @config.interfaces.size.should == 9
      end
      describe 'interface 0' do
        it 'should be named ge-0/0/0' do @config.interfaces[0].name.should == 'ge-0/0/0' end
      end
      describe 'interface 1' do
        it 'should be named ge-0/0/1' do @config.interfaces[1].name.should == 'ge-0/0/1' end
      end
      describe 'interface 2' do
        it 'should be named ge-2/0/0' do @config.interfaces[2].name.should == 'ge-2/0/0' end
      end
      describe 'interface 3' do
        it 'should be named ge-2/0/1' do @config.interfaces[3].name.should == 'ge-2/0/1' end
      end
      describe 'interface 4' do
        it 'should be named fab0' do @config.interfaces[4].name.should == 'fab0' end
      end
      describe 'interface 5' do
        it 'should be named fab1' do @config.interfaces[5].name.should == 'fab1' end
      end
      describe 'interface 6' do
        it 'should be named reth0' do @config.interfaces[6].name.should == 'reth0' end
      end
      describe 'interface 7' do
        it 'should be named reth1' do @config.interfaces[7].name.should == 'reth1' end
      end
      describe 'interface 8' do
        it 'should be named st0' do @config.interfaces[8].name.should == 'st0' end
      end
      
      it 'should have 3 security zones' do
        @config.security_zones.size.should == 3
      end
      describe 'security zone 0' do
        it 'should be named trust' do @config.security_zones[0].name.should == 'trust' end
      end
      describe 'security zone 1' do
        it 'should be named untrust' do @config.security_zones[1].name.should == 'untrust' end
      end
      describe 'security zone 2' do
        it 'should be named vpn' do @config.security_zones[2].name.should == 'vpn' end
      end
    end
  end
end
