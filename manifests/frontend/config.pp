# == Class zabbix::frontend::config
#
# This class is called from zabbix::frontend
#
class zabbix::frontend::config {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

  file { '/etc/zabbix/apache.conf':
    ensure => absent,
    before => Apache::Vhost[$zabbix::frontend::url]
  }

  class { 'apache':
    default_mods   => true,
    default_vhost  => false,
    mpm_module     => 'prefork',
    service_enable => true
  }

  apache::mod {'rewrite':}
  apache::mod {'php5':}

  $custom_fragment = '
  <Directory "/usr/share/zabbix/conf">
      Order deny,allow
      Deny from all
      <files *.php>
          Order deny,allow
          Deny from all
      </files>
  </Directory>

  <Directory "/usr/share/zabbix/api">
      Order deny,allow
      Deny from all
      <files *.php>
          Order deny,allow
          Deny from all
      </files>
  </Directory>

  <Directory "/usr/share/zabbix/include">
      Order deny,allow
      Deny from all
      <files *.php>
          Order deny,allow
          Deny from all
      </files>
  </Directory>

  <Directory "/usr/share/zabbix/include/classes">
      Order deny,allow
      Deny from all
      <files *.php>
          Order deny,allow
          Deny from all
      </files>
  </Directory>'

  if $ssl_redirect {
    apache::vhost { $zabbix::frontend::url:
      servername => $zabbix::frontend::url,
      port       => '80',
      docroot    => '/var/www',
      rewrites   => [{
        rewrite_cond  => '%{SERVER_PORT} 80',
        rewrite_rule  => "^(.*)$ https://${zabbix::frontend::url}/$1 [R=301,L]"
      }]
    } ->

    apache::vhost { "${zabbix::frontend::url}-ssl":
      servername      => $zabbix::frontend::url,
      port            => '443',
      docroot         => '/usr/share/zabbix',
      directories     => [{ 'path' => '/usr/share/zabbix', 'options' => 'FollowSymLinks', 'order' => 'allow,deny' }],
      custom_fragment => $custom_fragment,
      ssl             => true,
    }
  } else {
    apache::vhost { $zabbix::frontend::url:
      servername      => $zabbix::frontend::url,
      port            => '80',
      docroot         => '/usr/share/zabbix',
      directories     => [{ 'path' => '/usr/share/zabbix', 'options' => 'FollowSymLinks', 'order' => 'allow,deny' }],
      custom_fragment => $custom_fragment,
    }
  }

  Php::Config { file => $zabbix::frontend::php_ini_file, notify => Service['httpd'] }

  php::config { "max_execution_time=${zabbix::frontend::php_max_execution_time}":  }
  php::config { "max_input_time=${zabbix::frontend::php_max_input_time}":  }
  php::config { "memory_limit=${zabbix::frontend::php_memory_limit}":  }
  php::config { "post_max_size=${zabbix::frontend::php_post_max_size}":  }
  php::config { "date.timezone=${zabbix::frontend::php_timezone}":  }
  php::config { "upload_max_filesize=${zabbix::frontend::php_upload_max_filesize}":  }
  php::config { 'session.auto_start=0':  }

  file { $zabbix::frontend::conf_file:
    replace => true,
    mode    => 0644,
    owner   => $zabbix::frontend::apache_user,
    group   => $zabbix::frontend::apache_group,
    content => template('zabbix/zabbix.conf.php.erb'),
  }
}
