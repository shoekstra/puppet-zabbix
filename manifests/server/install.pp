# == Class zabbix::server::install
#
class zabbix::server::install {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

  class { 'zabbix::repo': } -> package { $zabbix::server::package_name: ensure => present }

  package { 'zabbixapi':
    ensure   => present,
    provider => 'gem',
  } 
}
