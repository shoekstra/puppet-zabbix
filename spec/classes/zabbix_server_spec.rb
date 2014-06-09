require 'spec_helper'

describe 'zabbix::server', :type => :class do
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
          :operatingsystem        => 'Ubuntu',
          :operatingsystemrelease => '12.04',
          :osfamily               => 'Debian',
        }
      end

      it { should compile.with_all_deps }

      it { should contain_class('zabbix::params') }
      it { should contain_class('zabbix::server::install').that_comes_before('zabbix::server::config') }
      it { should contain_class('zabbix::server::config') }
      it { should contain_class('zabbix::server::service').that_subscribes_to('zabbix::server::config').that_comes_before('zabbix::server') }
      it { should contain_class('zabbix::server') }

      describe "zabbix::server::install class" do
        it { should contain_class('zabbix::repo') }
        it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/ubuntu/') }
        it { should contain_apt__source('zabbix').with_release('precise') }
        it { should contain_apt__source('zabbix').with_repos('main') }
        it { should contain_apt__source('zabbix').with_key('79EA5ED4') }
        it { should contain_apt__source('zabbix').with_key_source('http://repo.zabbix.com/zabbix-official-repo.key') }
        it { should contain_package('zabbix-server-mysql').with_ensure('present') }
        it { should contain_package('zabbix-get').with_ensure('present') }
        it { should contain_package('zabbixapi').with_ensure('present') }
        it { should contain_package('zabbixapi').with_provider('gem') }
      end

      describe "zabbix::server::config class" do
        let :params do default_params end

        it { should contain_file('/etc/zabbix/zabbix_server.conf').with_ensure('present') }
        it { should contain_file('/etc/zabbix/zabbix_server.conf').with_mode('0644') }
        it { should contain_file('/etc/zabbix/zabbix_server.conf').with_owner('zabbix') }
        it { should contain_file('/etc/zabbix/zabbix_server.conf').with_group('root') }
      end

      describe "zabbix::server::service class" do
        it { should contain_service('zabbix-server').with_ensure('running') }
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

      describe "/etc/zabbix/zabbix_server.conf" do
        [
          {
            :title => 'should set alert scripts patch',
            :attr  => 'alertscriptspath',
            :value => '/usr/lib/zabbix/alertscripts',
            :match => [/^AlertScriptsPath=\/usr\/lib\/zabbix\/alertscripts$/]
          },
          {
            :title => 'should set cachesize',
            :attr  => 'cachesize',
            :value => '16M',
            :match => [/^CacheSize=16M$/]
          },
          {
            :title => 'should set cache update frequency',
            :attr  => 'cacheupdatefrequency',
            :value => 60,
            :match => [/^CacheUpdateFrequency=60$/]
          },
          {
            :title => 'should set database server name',
            :attr  => 'dbhost',
            :value => 'localhost',
            :match => [/^DBHost=localhost$/]
          },
          {
            :title => 'should set database port',
            :attr  => 'dbport',
            :value => 6446,
            :match => [/^DBPort=6446$/]
          },
          {
            :title => 'should set database socket path',
            :attr  => 'dbsocket',
            :value => '/tmp/mysqld.sock',
            :match => [/^DBSocket=\/tmp\/mysqld.sock$/]
          },
          {
            :title => 'should set database name',
            :attr  => 'dbname',
            :value => 'zabbix-db',
            :match => [/^DBName=zabbix-db$/]
          },
          {
            :title => 'should set database username',
            :attr  => 'dbuser',
            :value => 'zabbix-user',
            :match => [/^DBUser=zabbix-user$/]
          },
          {
            :title => 'should set database password',
            :attr  => 'dbpass',
            :value => 'zabbix-pass',
            :match => [/^DBPassword=zabbix-pass$/]
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
            :title => 'should set max rows to delete when housekeeping',
            :attr  => 'maxhousekeeperdelete',
            :value => 1000,
            :match => [/^MaxHousekeeperDelete=1000$/]
          },
          {
            :title => 'should disable node events',
            :attr  => 'nodenoevents',
            :value => true,
            :match => [/^NodeNoEvents=1$/]
          },
          {
            :title => 'should not disable node events',
            :attr  => 'nodenoevents',
            :value => false,
            :match => [/^NodeNoEvents=0$/]
          },
          {
            :title => 'should disable node history',
            :attr  => 'nodenohistory',
            :value => true,
            :match => [/^NodeNoHistory=1$/]
          },
          {
            :title => 'should not disable node history',
            :attr  => 'nodenohistory',
            :value => false,
            :match => [/^NodeNoHistory=0$/]
          },
          {
            :title => 'should set pid file',
            :attr  => 'pidfile',
            :value => '/tmp/zabbix_server.pid',
            :match => [/^PidFile=\/tmp\/zabbix_server.pid$/]
          },
          {
            :title => 'should set proxy config frequency',
            :attr  => 'proxyconfigfrequency',
            :value => 600,
            :match => [/^ProxyConfigFrequency=600$/]
          },
          {
            :title => 'should set proxy data frequency',
            :attr  => 'proxydatafrequency',
            :value => 1,
            :match => [/^ProxyDataFrequency=1$/]
          },
          {
            :title => 'should set sender frequency',
            :attr  => 'senderfrequency',
            :value => 30,
            :match => [/^SenderFrequency=30$/]
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
            :title => 'should set number of agent pollers to part',
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
            :title => 'should set number of proxy pollers to start',
            :attr  => 'startproxypollers',
            :value => 1,
            :match => [/^StartProxyPollers=1$/]
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
            :title => 'should set number of timers to start',
            :attr  => 'starttimers',
            :value => 5,
            :match => [/^StartTimers=5$/]
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
            :title => 'should set trend cache size',
            :attr  => 'trendcachesize',
            :value => '8M',
            :match => [/^TrendCacheSize=8M$/]
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
            :title => 'should set valuecachesize',
            :attr  => 'valuecachesize',
            :value => '16M',
            :match => [/^ValueCacheSize=16M$/]
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
                should contain_file('/etc/zabbix/zabbix_server.conf').with_content(match)
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

      it { expect { should contain_package('zabbix-server-mysql') }.to raise_error(Puppet::Error, /zabbix module not supported on Nexenta operatingsystem/) }
    end
  end
end
