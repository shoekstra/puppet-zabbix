require 'spec_helper'

describe 'zabbix::database::mysql', :type => :class do
  let :default_params do
    {
      :root_password => 't0p_s3cr3t'
    }
  end
  let :default_facts do
    {
      :ipaddress => '192.168.1.10',
      :root_home => '/root',
    }
  end
  context 'supported operating systems' do
    ['Ubuntu'].each do |operatingsystem|
      describe "on #{operatingsystem}" do
        let :params do default_params end
        let :facts do default_facts.merge( {
          :lsbdistcodename        => 'precise',
          :lsbdistid              => 'Ubuntu',
          :operatingsystem        => 'Ubuntu',
          :operatingsystemrelease => '12.04',
          :osfamily               => 'Debian',
          })
        end

        it { should compile.with_all_deps }

        it { should contain_class('zabbix::params') }

        it { should contain_class('mysql::server').that_comes_before('Mysql::Db[zabbix]') }
        it { should contain_class('mysql::server').with_override_options('mysqld' => { 'bind-address' => '127.0.0.1' }) }
        it { should contain_class('mysql::server').with_restart('true') }
        it { should contain_class('mysql::server').with_root_password('t0p_s3cr3t') }

        it { should contain_mysql__db('zabbix').that_comes_before('Mysql_user[zabbix@192.168.1.10]') }
        it { should contain_mysql__db('zabbix').with_charset('utf8') }
        it { should contain_mysql__db('zabbix').with_collate('utf8_bin') }
        it { should contain_mysql__db('zabbix').with_user('zabbix') }
        it { should contain_mysql__db('zabbix').with_password('zabbix') }
        it { should contain_mysql__db('zabbix').with_host('localhost') }
        it { should contain_mysql__db('zabbix').with_grant('ALL') }

        it { should contain_mysql_user('zabbix@192.168.1.10').that_comes_before('Mysql_grant[zabbix@192.168.1.10/zabbix.*]').that_requires('Mysql::Server') }
        it { should contain_mysql_user('zabbix@192.168.1.10').with_ensure('present') }
        it { should contain_mysql_user('zabbix@192.168.1.10').with_password_hash('*DEEF4D7D88CD046ECA02A80393B7780A63E7E789') }

        it { should contain_mysql_grant('zabbix@192.168.1.10/zabbix.*').that_comes_before('File[/usr/share/zabbix-server-mysql]') }
        it { should contain_mysql_grant('zabbix@192.168.1.10/zabbix.*').with_ensure('present') }
        it { should contain_mysql_grant('zabbix@192.168.1.10/zabbix.*').with_options(['GRANT']) }
        it { should contain_mysql_grant('zabbix@192.168.1.10/zabbix.*').with_privileges(['ALL']) }
        it { should contain_mysql_grant('zabbix@192.168.1.10/zabbix.*').with_table('zabbix.*') }
        it { should contain_mysql_grant('zabbix@192.168.1.10/zabbix.*').with_user('zabbix@192.168.1.10') }

        it { should contain_file('/usr/share/zabbix-server-mysql').with_ensure('directory').that_comes_before('Exec[mysql-schema.sql-import]') }
        it { should contain_file('/usr/share/zabbix-server-mysql').with_owner('root') }
        it { should contain_file('/usr/share/zabbix-server-mysql').with_group('root') }
        it { should contain_file('/usr/share/zabbix-server-mysql').with_recurse(true) }
        it { should contain_file('/usr/share/zabbix-server-mysql').with_source('puppet:///modules/zabbix/mysql') }
        it { should contain_file('/usr/share/zabbix-server-mysql').with_ignore(['.git','.svn']) }

        it { should contain_exec('mysql-schema.sql-import').that_comes_before('Exec[mysql-images.sql-import]') }
        it { should contain_exec('mysql-schema.sql-import').with_command('/usr/bin/mysql zabbix < /usr/share/zabbix-server-mysql/schema.sql') }
        it { should contain_exec('mysql-schema.sql-import').with_unless("/usr/bin/test 109 -eq $(mysql -u root -e 'SHOW TABLES' zabbix | wc -l)") }
        it { should contain_exec('mysql-schema.sql-import').with_environment('HOME=/root') }

        it { should contain_exec('mysql-images.sql-import').that_comes_before('Exec[mysql-data.sql-import]') }
        it { should contain_exec('mysql-images.sql-import').with_command('/usr/bin/mysql zabbix < /usr/share/zabbix-server-mysql/images.sql') }
        it { should contain_exec('mysql-images.sql-import').with_unless("/usr/bin/test 188 -eq $(mysql -u root -e 'SELECT * FROM images' zabbix | wc -l)") }
        it { should contain_exec('mysql-images.sql-import').with_environment('HOME=/root') }

        it { should contain_exec('mysql-data.sql-import').with_command('/usr/bin/mysql zabbix < /usr/share/zabbix-server-mysql/data.sql') }
        it { should contain_exec('mysql-data.sql-import').with_unless("/usr/bin/test 2 -eq $(mysql -u root -e 'SELECT * FROM config' zabbix | wc -l)") }
        it { should contain_exec('mysql-data.sql-import').with_environment('HOME=/root') }
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
