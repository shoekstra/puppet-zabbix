# == Class zabbix::frontend::install
#
class zabbix::frontend::install {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

  class { 'zabbix::repo': } -> package { $zabbix::frontend::package_name: ensure => present }
}
