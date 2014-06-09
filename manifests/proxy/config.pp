# == Class zabbix::proxy::config
#
# This class is called from zabbix
#
class zabbix::proxy::config {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

  file { $zabbix::proxy::conf_file:
    ensure  => present,
    mode    => 0644,
    owner   => 'zabbix',
    group   => 'root',
    content => template('zabbix/zabbix_proxy.conf.erb')
  }
}
