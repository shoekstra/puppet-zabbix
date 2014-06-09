# == Class zabbix::database::mysql
#
# This class installs and configure MySQL for Zabbix.
#
class zabbix::database::mysql (
    $root_password,
    $bind_address = '127.0.0.1',
    $db_name = 'zabbix',
    $db_pass = 'zabbix',
    $db_user = 'zabbix',
    $node_ip = $::ipaddress,
    $frontend_ip = $::ipaddress,
    $restart = true,
) inherits zabbix::params {

  class { '::mysql::server':
    override_options => {
      'mysqld' => { 'bind-address' => $bind_address },
    },
    restart          => $restart,
    root_password    => $root_password
  } ->

  mysql::db { $db_name:
    charset  => 'utf8',
    collate  => 'utf8_bin',
    user     => $db_user,
    password => $db_pass,
    host     => 'localhost',
    grant    => 'ALL',
  } ->

  mysql_user{ "${db_user}@${frontend_ip}":
    ensure        => present,
    password_hash => mysql_password($db_pass),
    require       => Class['mysql::server'],
  } ->

  mysql_grant { "${db_user}@${frontend_ip}/${db_name}.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => "${db_name}.*",
    user       => "${db_user}@${frontend_ip}",
    before     => File[$server_share_dir]
  }

  if $frontend_ip != $node_ip {
    mysql_user{ "${db_user}@${node_ip}":
      ensure        => present,
      password_hash => mysql_password($db_pass),
      require       => Mysql_grant["${db_user}@${frontend_ip}/${db_name}.*"],
    } ->

    mysql_grant { "${db_user}@${node_ip}/${db_name}.*":
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => ['ALL'],
      table      => "${db_name}.*",
      user       => "${db_user}@${node_ip}",
      before     => File[$server_share_dir]
    }
  }

  file { $server_share_dir: 
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    recurse => true,
    source  => 'puppet:///modules/zabbix/mysql',
    ignore  => ['.git', '.svn'],
  } ->

  exec { 'mysql-schema.sql-import':
    command     => "/usr/bin/mysql ${db_name} < ${server_share_dir}/schema.sql",
    unless      => "/usr/bin/test 109 -eq $(mysql -u root -e 'SHOW TABLES' ${db_name} | wc -l)",
    environment => "HOME=${::root_home}",
  } ->

  exec { 'mysql-images.sql-import':
    command     => "/usr/bin/mysql ${db_name} < ${server_share_dir}/images.sql",
    unless      => "/usr/bin/test 188 -eq $(mysql -u root -e 'SELECT * FROM images' ${db_name} | wc -l)",
    environment => "HOME=${::root_home}",
  } ->

  exec { 'mysql-data.sql-import':
    command     => "/usr/bin/mysql ${db_name} < ${server_share_dir}/data.sql",
    unless      => "/usr/bin/test 2 -eq $(mysql -u root -e 'SELECT * FROM config' ${db_name} | wc -l)",
    environment => "HOME=${::root_home}",
  }
}
