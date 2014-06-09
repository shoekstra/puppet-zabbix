# == Class zabbix::agent::install
#
class zabbix::agent::install {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

  class { 'zabbix::repo': } -> package { $zabbix::agent::package_name: ensure => present }
}
