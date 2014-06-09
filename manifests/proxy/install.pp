# == Class zabbix::proxy::install
#
class zabbix::proxy::install {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

  class { 'zabbix::repo': } -> package { $zabbix::proxy::package_name: ensure => present }
}
