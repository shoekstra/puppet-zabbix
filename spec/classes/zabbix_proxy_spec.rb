require 'spec_helper'

describe 'zabbix::proxy', :type => :class do
  let :default_params do
    {
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
          :osfamily               => 'Debian',
        }
      end

      it { should compile.with_all_deps }

      it { should contain_class('zabbix::params') }
      it { should contain_class('zabbix::proxy::install').that_comes_before('zabbix::proxy::config') }
      it { should contain_class('zabbix::proxy::config') }
      it { should contain_class('zabbix::proxy::service').that_subscribes_to('zabbix::proxy::config').that_comes_before('zabbix::proxy') }
      it { should contain_class('zabbix::proxy') }

      describe "zabbix::proxy::install class" do
        it { should contain_class('zabbix::repo') }
        it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/ubuntu/') }
        it { should contain_apt__source('zabbix').with_release('precise') }
        it { should contain_apt__source('zabbix').with_repos('main') }
        it { should contain_apt__source('zabbix').with_key('79EA5ED4') }
        it { should contain_apt__source('zabbix').with_key_source('http://repo.zabbix.com/zabbix-official-repo.key') }
        it { should contain_package('zabbix-proxy-sqlite3').with_ensure('present') }
      end

      describe "zabbix::proxy::config class" do
        let :params do default_params end

        it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_ensure('present') }
        it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_mode('0644') }
        it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_owner('zabbix') }
        it { should contain_file('/etc/zabbix/zabbix_proxy.conf').with_group('root') }
      end

      describe "zabbix::proxy::service class" do
        it { should contain_service('zabbix-proxy').with_ensure('running') }
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

      describe "/etc/zabbix/zabbix_proxy.conf" do
        [
          {
            :title => 'should set cachesize',
            :attr  => 'cachesize',
            :value => '16M',
            :match => [/^CacheSize=16M$/]
          },
          {
            :title => 'should set config frequency',
            :attr  => 'configfrequency',
            :value => 600,
            :match => [/^ConfigFrequency=600$/]
          },
          {
            :title => 'should set data sender frequency',
            :attr  => 'datasenderfrequency',
            :value => 60,
            :match => [/^DataSenderFrequency=60$/]
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
            :title => 'should set external scripts dir',
            :attr  => 'externalscripts',
            :value => '/zabbix/externalscripts',
            :match => [/^ExternalScripts=\/zabbix\/externalscripts$/]
          },
          {
            :title => 'should set heartbeat frequency',
            :attr  => 'heartbeatfrequency',
            :value => '300',
            :match => [/^HeartbeatFrequency=300$/]
          },
          {
            :title => 'should set history cache size',
            :attr  => 'historycachesize',
            :value => '16M',
            :match => [/^HistoryCacheSize=16M$/]
          },
          {
            :title => 'should set history text cache size',
            :attr  => 'historytextcachesize',
            :value => '32M',
            :match => [/^HistoryTextCacheSize=32M$/]
          },
          {
            :title => 'should set housekeeping frequency',
            :attr  => 'housekeepingfrequency',
            :value => '2',
            :match => [/^HousekeepingFrequency=2$/]
          },
          {
            :title => 'should set one include dir',
            :attr  => 'include',
            :value => '/path/to/includes',
            :match => [/^Include=\/path\/to\/includes$/]
          },
          {
            :title => 'should set multiple include dirs',
            :attr  => 'include',
            :value => ['/path/to/includes','/another/include/dir'],
            :match => [
              /^Include=\/path\/to\/includes$/,
              /^Include=\/another\/include\/dir$/
            ]
          },
          {
            :title => 'should set java gateway server',
            :attr  => 'javagateway',
            :value => '192.168.44.22',
            :match => [/^JavaGateway=192.168.44.22$/]
          },
          {
            :title => 'should set java gateway port',
            :attr  => 'javagatewayport',
            :value => 10052,
            :match => [/^JavaGatewayPort=10052$/]
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
            :title => 'should set loadmodule path',
            :attr  => 'loadmodulepath',
            :value => '/etc/zabbix/modules',
            :match => [/^LoadModulePath=\/etc\/zabbix\/modules$/]
          },
          {
            :title => 'should load one module',
            :attr  => 'loadmodule',
            :value => 'module1.so',
            :match => [/^LoadModule=module1.so$/]
          },
          {
            :title => 'should load multiple modules',
            :attr  => 'loadmodule',
            :value => ['module1.so','module2.so','module3.so'],
            :match => [
              /^LoadModule=module1.so$/,
              /^LoadModule=module2.so$/,
              /^LoadModule=module3.so$/
            ]
          },
          {
            :title => 'should set log file path',
            :attr  => 'logfile',
            :value => '/logs/zabbix/zabbix_server.log',
            :match => [/^LogFile=\/logs\/zabbix\/zabbix_server.log$/]
          },
          {
            :title => 'should set log file size',
            :attr  => 'logfilesize',
            :value => 5,
            :match => [/^LogFileSize=5$/]
          },
          {
            :title => 'should slow query logging threshold',
            :attr  => 'logslowqueries',
            :value => 3000,
            :match => [/^LogSlowQueries=3000$/]
          },
          {
            :title => 'should disable slow query logging threshold',
            :attr  => 'logslowqueries',
            :value => 0,
            :match => [/^$/]
          },
          {
            :title => 'should set proxy mode',
            :attr  => 'mode',
            :value => 'active',
            :match => [/^ProxyMode=1$/]
          },
          {
            :title => 'should set proxy mode',
            :attr  => 'mode',
            :value => 'passive',
            :match => [/^ProxyMode=0$/]
          },
          {
            :title => 'should set pid file',
            :attr  => 'pidfile',
            :value => '/tmp/zabbix_server.pid',
            :match => [/^PidFile=\/tmp\/zabbix_server.pid$/]
          },
          {
            :title => 'should set proxy local buffer',
            :attr  => 'proxylocalbuffer',
            :value => '12',
            :match => [/^ProxyLocalBuffer=12$/]
          },
          {
            :title => 'should set proxy offline buffer',
            :attr  => 'proxyofflinebuffer',
            :value => '12',
            :match => [/^ProxyOfflineBuffer=12$/]
          },
          {
            :title => 'should set server address',
            :attr  => 'server',
            :value => 'zabbix-server.example.com',
            :match => [/^Server=zabbix-server.example.com$/]
          },
          {
            :title => 'should set server port',
            :attr  => 'serverport',
            :value => '10050',
            :match => [/^ServerPort=10050$/]
          },
          {
            :title => 'should set source ip',
            :attr  => 'sourceip',
            :value => '192.168.133.20',
            :match => [/^SourceIP=192.168.133.20$/]
          },
          {
            :title => 'should set sshkey dir',
            :attr  => 'sshkeylocation',
            :value => '/sshkeys',
            :match => [/^SSHKeyLocation=\/sshkeys$/]
          },
          {
            :title => 'should set number of db syncers to start',
            :attr  => 'startdbsyncers',
            :value => 4,
            :match => [/^StartDBSyncers=4$/]
          },
          {
            :title => 'should set number of discovers to start',
            :attr  => 'startdiscoverers',
            :value => 1,
            :match => [/^StartDiscoverers=1$/]
          },
          {
            :title => 'should set number of http pollers to start',
            :attr  => 'starthttppollers',
            :value => 1,
            :match => [/^StartHTTPPollers=1$/]
          },
          {
            :title => 'should set number of ipmi pollers to start',
            :attr  => 'startipmipollers',
            :value => 0,
            :match => [/^StartIPMIPollers=0$/]
          },
          {
            :title => 'should set number of java pollers to start',
            :attr  => 'startjavapollers',
            :value => 0,
            :match => [/^StartJavaPollers=0$/]
          },
          {
            :title => 'should set number of pingers to start',
            :attr  => 'startpingers',
            :value => 1,
            :match => [/^StartPingers=1$/]
          },
          {
            :title => 'should set number of agent pollers to start',
            :attr  => 'startpollers',
            :value => 5,
            :match => [/^StartPollers=5$/]
          },
          {
            :title => 'should set number of unreachable pollers to start',
            :attr  => 'startpollersunreachable',
            :value => 1,
            :match => [/^StartPollersUnreachable=1$/]
          },
          {
            :title => 'should enable snmp trapper at start',
            :attr  => 'startsnmptrapper',
            :value => true,
            :match => [/^$/]
          },
          {
            :title => 'should disable snmp trapper at start',
            :attr  => 'startsnmptrapper',
            :value => false,
            :match => [/^$/]
          },
          {
            :title => 'should set number of trappers to start',
            :attr  => 'starttrappers',
            :value => 10,
            :match => [/^StartTrappers=10$/]
          },
          {
            :title => 'should set number of vmware collectors to start',
            :attr  => 'startvmwarecollectors',
            :value => 5,
            :match => [/^StartVMwareCollectors=5$/]
          },
          {
            :title => 'should set timeout period',
            :attr  => 'timeout',
            :value => 5,
            :match => [/^Timeout=5$/]
          },
          {
            :title => 'should set tmp dir',
            :attr  => 'tmpdir',
            :value => '/var/tmp',
            :match => [/^TmpDir=\/var\/tmp$/]
          },
          {
            :title => 'should set trapper timeout period',
            :attr  => 'trappertimeout',
            :value => 30,
            :match => [/^TrapperTimeout=30$/]
          },
          {
            :title => 'should set unavailabley delay',
            :attr  => 'unavailabledelay',
            :value => 300,
            :match => [/^UnavailableDelay=300$/]
          },
          {
            :title => 'should set unreachable delay',
            :attr  => 'unreachabledelay',
            :value => 10,
            :match => [/^UnreachableDelay=10$/]
          },
          {
            :title => 'should set unreachable period',
            :attr  => 'unreachableperiod',
            :value => 30,
            :match => [/^UnreachablePeriod=30$/]
          },
          {
            :title => 'should set vmware cache size',
            :attr  => 'vmwarecachesize',
            :value => '16M',
            :match => [/^VMwareCacheSize=16M$/]
          },
          {
            :title => 'should set vmware frequency',
            :attr  => 'vmwarefrequency',
            :value => 30,
            :match => [/^VMwareFrequency=30$/]
          }
        ].each do |param|
          describe "when \$#{param[:attr]} is #{param[:value]}" do
            let :params do default_params.merge({ param[:attr].to_sym => param[:value] }) end

            it "#{param[:title]} to \'#{param[:value]}\'" do
              param[:match].each do |match|
                should contain_file('/etc/zabbix/zabbix_proxy.conf').with_content(match)
              end
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

      it { expect { should contain_package('zabbix-proxy-sqlite3') }.to raise_error(Puppet::Error, /zabbix module not supported on Nexenta operatingsystem/) }
    end
  end
end
