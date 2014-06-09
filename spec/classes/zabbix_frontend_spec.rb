require 'spec_helper'

describe 'zabbix::frontend', :type => :class do
  let :default_facts do
    {
      :concat_basedir => '/var/lib/puppet/concat',
    }
  end

  context 'supported operating systems' do
    describe "on Ubuntu" do
      let :facts do default_facts.merge(
        {
          :lsbdistcodename        => 'precise',
          :lsbdistid              => 'Ubuntu',
          :operatingsystemrelease => '12.04',
          :operatingsystem        => 'Ubuntu',
          :osfamily               => 'Debian',
        })
      end

      it { should compile.with_all_deps }

      it { should contain_class('zabbix::params') }
      it { should contain_class('zabbix::frontend::install').that_comes_before('zabbix::frontend::config') }
      it { should contain_class('zabbix::frontend::config').that_comes_before('zabbix::frontend') }
      it { should contain_class('zabbix::frontend') }

      describe "zabbix::frontend::install class" do
        it { should contain_class('zabbix::repo') }
        it { should contain_apt__source('zabbix').with_location('http://repo.zabbix.com/zabbix/2.2/ubuntu/') }
        it { should contain_apt__source('zabbix').with_release('precise') }
        it { should contain_apt__source('zabbix').with_repos('main') }
        it { should contain_apt__source('zabbix').with_key('79EA5ED4') }
        it { should contain_apt__source('zabbix').with_key_source('http://repo.zabbix.com/zabbix-official-repo.key') }
        it { should contain_package('zabbix-frontend-php').with_ensure('present') }
      end

      describe "zabbix::frontend::config class" do
        it { should contain_file('/etc/zabbix/apache.conf').with_ensure('absent') }

        it { should contain_class('apache').with_default_mods('true') }
        it { should contain_class('apache').with_default_vhost('false') }
        it { should contain_class('apache').with_mpm_module('prefork') }
        it { should contain_class('apache').with_service_enable('true') }

        it { should contain_apache__mod('rewrite') }
        it { should contain_apache__mod('php5') }

        it { should contain_php__config('session.auto_start=0').with_file('/etc/php5/apache2/php.ini').that_notifies('Service[httpd]') }

        it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_replace('true') }
        it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_mode('0644') }
        it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_owner('www-data') }
        it { should contain_file('/etc/zabbix/web/zabbix.conf.php').with_group('www-data') }
      end
    end

    describe "validate parameters for config files" do
      let :facts do default_facts.merge(
        {
          :lsbdistcodename        => 'precise',
          :lsbdistid              => 'Ubuntu',
          :operatingsystemrelease => '12.04',
          :operatingsystem        => 'Ubuntu',
          :osfamily               => 'Debian',
        })
      end

      context 'php config' do
        [
          {
            :title => 'should set php max_execution_time',
            :attr  => 'php_max_execution_time',
            :value => '600',
            :match => 'max_execution_time=600'
          },
          {
            :title => 'should set php max_input_time',
            :attr  => 'php_max_input_time',
            :value => '600',
            :match => 'max_input_time=600'
          },
          {
            :title => 'should set php memory_limit',
            :attr  => 'php_memory_limit',
            :value => '256M',
            :match => 'memory_limit=256M'
          },
          {
            :title => 'should set php post_max_size',
            :attr  => 'php_post_max_size',
            :value => '32M',
            :match => 'post_max_size=32M'
          },
          {
            :title => 'should set php date.timezone',
            :attr  => 'php_timezone',
            :value => 'GMT',
            :match => 'date.timezone=GMT'
          },
          {
            :title => 'should set php upload_max_filesize',
            :attr  => 'php_upload_max_filesize',
            :value => '4M',
            :match => 'upload_max_filesize=4M'
          },
        ].each do |param|
          describe "when \$#{param[:attr]} is #{param[:value]}" do
            let :params do { param[:attr].to_sym => param[:value] } end

            it "#{param[:title]} to \'#{param[:value]}\'" do
              should contain_php__config(param[:match]).with_file('/etc/php5/apache2/php.ini').that_notifies('Service[httpd]')
            end
          end
        end
      end

      describe "/etc/zabbix/zabbix_agentd.conf" do
        [
          {
            :title => 'should set database server',
            :attr  => 'dbhost',
            :value => 'localhost',
            :match => [/^\$DB\['SERVER'\]   = 'localhost';$/]
          },
          {
            :title => 'should set database name',
            :attr  => 'dbname',
            :value => 'zabbix',
            :match => [/^\$DB\['DATABASE'\] = 'zabbix';$/]
          },
          {
            :title => 'should set database username',
            :attr  => 'dbuser',
            :value => 'zabbix',
            :match => [/^\$DB\['USER'\]     = 'zabbix';$/]
          },
          {
            :title => 'should set database password',
            :attr  => 'dbpass',
            :value => 'zabbix',
            :match => [/^\$DB\['PASSWORD'\] = 'zabbix';$/]
          },
          {
            :title => 'should set zabbix server',
            :attr  => 'server',
            :value => 'localhost',
            :match => [/^\$ZBX_SERVER      = 'localhost';$/]
          },
          {
            :title => 'should set zabbix server port',
            :attr  => 'serverport',
            :value => '10051',
            :match => [/^\$ZBX_SERVER_PORT = '10051';$/]
          },
          {
            :title => 'should set zabbix server name',
            :attr  => 'servername',
            :value => 'zabbix',
            :match => [/^\$ZBX_SERVER_NAME = 'zabbix';$/]
          },
        ].each do |param|
          describe "when \$#{param[:attr]} is #{param[:value]}" do
            let :params do { param[:attr].to_sym => param[:value] } end

            it "#{param[:title]} to \'#{param[:value]}\'" do
              should contain_file('/etc/zabbix/web/zabbix.conf.php').with_content(param[:match])
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
