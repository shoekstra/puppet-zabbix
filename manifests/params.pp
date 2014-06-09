# == Class zabbix::params
#
# This class is meant to be called from zabbix
# It sets variables according to platform
#
class zabbix::params {
  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $agent_conf_file = '/etc/zabbix/zabbix_agentd.conf'
      $agent_include_dir = '/etc/zabbix/zabbix_agentd.d'
      $agent_package_name = ['zabbix-agent','zabbix-sender']
      $agent_service_name = 'zabbix-agent'
      $apache_group = 'www-data'
      $apache_user = 'www-data'
      $fping6_bin = '/usr/bin/fping6'
      $fping_bin = '/usr/bin/fping'
      $frontend_conf_file = '/etc/zabbix/web/zabbix.conf.php'
      $frontend_package_name = 'zabbix-frontend-php'
      $php_ini_file = '/etc/php5/apache2/php.ini'
      $proxy_conf_file = '/etc/zabbix/zabbix_proxy.conf'
      $proxy_package_name = 'zabbix-proxy-sqlite3'
      $proxy_service_name = 'zabbix-proxy'
      $proxy_sqlite_file = '/var/lib/zabbix/zabbix_proxy.db'
      $server_conf_file = '/etc/zabbix/zabbix_server.conf'
      $server_package_name = ['zabbix-get','zabbix-server-mysql']
      $server_service_name = 'zabbix-server'
      $server_share_dir = '/usr/share/zabbix-server-mysql'
    }
    default: {
      fail("${module_name} module not supported on ${::operatingsystem} operatingsystem")
    }
  }

  # common variables
  
}
