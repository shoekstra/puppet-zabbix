require 'spec_helper'

describe 'zabbix::agent', :type => :class do
  let :default_params do
    {
      :server => 'zabbix-server.example.com'
    }
  end

  context 'supported operating systems' do
    describe "on Ubuntu" do
      let :facts do 
        {
          :lsbdistcodename        => 'precise',
          :lsbdistid              => 'Ubuntu',
          :operatingsystemrelease => '12.04',
          :operatingsystem        => 'Ubuntu',
        }
      end 
      let :params do default_params end

      it { should compile.with_all_deps }

      it { should contain_class('zabbix::params') }
      it { should contain_class('zabbix::agent::install').that_comes_before('zabbix::agent::config') }
      it { should contain_class('zabbix::agent::config') }
      it { should contain_class('zabbix::agent::service').that_subscribes_to('zabbix::agent::config').that_comes_before('zabbix::agent') }
      it { should contain_class('zabbix::agent') }

      describe "zabbix::agent::install class" do
        it { should contain_class('zabbix::repo') }
        it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/ubuntu/') }
        it { should contain_apt__source('zabbix').with_release('precise') }
        it { should contain_apt__source('zabbix').with_repos('main') }
        it { should contain_apt__source('zabbix').with_key('79EA5ED4') }
        it { should contain_apt__source('zabbix').with_key_source('http://repo.zabbix.com/zabbix-official-repo.key') }

        it { should contain_package('zabbix-agent').with_ensure('present') }
        it { should contain_package('zabbix-sender').with_ensure('present') }
      end

      describe "zabbix::agent::config class" do
        let :params do default_params end

        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_ensure('present') }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_mode('0644') }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_owner('root') }
        it { should contain_file('/etc/zabbix/zabbix_agentd.conf').with_group('root') }
      end

      describe "zabbix::agent::service class" do
        it { should contain_service('zabbix-agent').with_ensure('running') }
      end
    end

    describe "validate parameters for config files" do
      let :facts do
        {
          :lsbdistcodename        => 'precise',
          :lsbdistid              => 'Ubuntu',
          :operatingsystemrelease => '12.04',
          :operatingsystem        => 'Ubuntu',
          :osfamily               => 'Debian',
        }
      end

      describe "/etc/zabbix/zabbix_agentd.conf" do
        [
          {
            :title => 'should allow unsafe user parameters',
            :attr  => 'allowunsafeuserparameters',
            :value => true,
            :match => [/^UnsafeUserParameters=1$/]
          },
          {
            :title => 'should not allow unsafe user parameters',
            :attr  => 'allowunsafeuserparameters',
            :value => false,
            :match => [/^UnsafeUserParameters=0$/]
          },
          {
            :title => 'should set buffer send',
            :attr  => 'buffersend',
            :value => '50',
            :match => [/^BufferSend=50$/]
          },
          {
            :title => 'should set buffer size',
            :attr  => 'buffersize',
            :value => '333',
            :match => [/^BufferSize=333$/]
          },
          {
            :title => 'should set debuglevel',
            :attr  => 'debuglevel',
            :value => 'none',
            :match => [/^DebugLevel=0$/]
          },
          {
            :title => 'should set debuglevel',
            :attr  => 'debuglevel',
            :value => 'critical',
            :match => [/^DebugLevel=1$/]
          },
          {
            :title => 'should set debuglevel',
            :attr  => 'debuglevel',
            :value => 'error',
            :match => [/^DebugLevel=2$/]
          },
          {
            :title => 'should set debuglevel',
            :attr  => 'debuglevel',
            :value => 'warnings',
            :match => [/^DebugLevel=3$/]
          },
          {
            :title => 'should set debuglevel',
            :attr  => 'debuglevel',
            :value => 'debug',
            :match => [/^DebugLevel=4$/]
          },
          {
            :title => 'should set listen ip',
            :attr  => 'listenip',
            :value => '192.168.133.20',
            :match => [/^ListenIP=192.168.133.20$/]
          },
          {
            :title => 'should set listen port',
            :attr  => 'listenport',
            :value => 10051,
            :match => [/^ListenPort=10051$/]
          },
          {
            :title => 'should set log file path',
            :attr  => 'logfile',
            :value => '/var/log/zabbix/zabbix_agentd.log',
            :match => [/^LogFile=\/var\/log\/zabbix\/zabbix_agentd.log$/]
          },
          {
            :title => 'should set log file size',
            :attr  => 'logfilesize',
            :value => 100,
            :match => [/^LogFileSize=100$/]
          },
          {
            :title => 'should set pid file',
            :attr  => 'pidfile',
            :value => '/var/run/zabbix/zabbix_agentd.pid',
            :match => [/^PidFile=\/var\/run\/zabbix\/zabbix_agentd.pid$/]
          },
          {
            :title => 'should set server hostname',
            :attr  => 'server',
            :value => 'zabbix-server.example.com',
            :match => [/^Server=zabbix-server.example.com$/]
          },
          {
            :title => 'should set multiple server hostnames',
            :attr  => 'server',
            :value => ['zabbix-server.example.com','zabbix-proxy1.example.com','zabbix-proxy2.example.com'],
            :match => [/^Server=zabbix-server.example.com,zabbix-proxy1.example.com,zabbix-proxy2.example.com$/]
          },
          {
            :title => 'should set source ip',
            :attr  => 'sourceip',
            :value => '192.168.33.120',
            :match => [/^SourceIP=192.168.33.120$/]
          },
          {
            :title => 'should set number of zabbix_agentd instances to start',
            :attr  => 'startagents',
            :value => 5,
            :match => [/^StartAgents=5$/]
          },
          {
            :title => 'should set timeout period',
            :attr  => 'timeout',
            :value => 3,
            :match => [/^Timeout=3$/]
          },
        ].each do |param|
          describe "when \$#{param[:attr]} is #{param[:value]}" do
            let :params do default_params.merge({ param[:attr].to_sym => param[:value] }) end

            it "#{param[:title]} to \'#{param[:value]}\'" do
              should contain_file('/etc/zabbix/zabbix_agentd.conf').with_content(param[:match])
            end
          end
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'on Solaris/Nexenta' do
      let(:facts) {{
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('zabbix-agent') }.to raise_error(Puppet::Error, /zabbix module not supported on Nexenta operatingsystem/) }
    end
  end
end
