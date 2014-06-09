# == Class: zabbix::frontend
#
# Full description of class zabbix here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class zabbix::frontend (
    $dbname = 'zabbix',
    $dbuser = 'zabbix',
    $dbpass = 'zabbix',
    $dbhost = 'localhost',
    $dbtype = 'mysql',
    $php_max_execution_time = 300,
    $php_max_input_time = '300',
    $php_memory_limit = '128M',
    $php_post_max_size = '16M',
    $php_timezone = 'UTC',
    $php_upload_max_filesize = '2M',
    $server = 'localhost',
    $servername = 'zabbix',
    $serverport = '10051',
    $ssl_redirect = true,
    $url = $::fqdn,
) inherits zabbix::params {

  $conf_file = $zabbix::params::frontend_conf_file
  $package_name = $zabbix::params::frontend_package_name
  $service_name = $zabbix::params::frontend_service_name

  validate_bool($ssl_redirect)

  class { 'zabbix::frontend::install': } ->
  class { 'zabbix::frontend::config': } ->
  Class['zabbix::frontend']
}
