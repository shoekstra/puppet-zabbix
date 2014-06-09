# == Class zabbix::server::config
#
# This class is called from zabbix
#
class zabbix::server::config {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

  file { $zabbix::server::conf_file:
    ensure  => present,
    mode    => 0644,
    owner   => 'zabbix',
    group   => 'root',
    content => template('zabbix/zabbix_server.conf.erb')
  }
}
