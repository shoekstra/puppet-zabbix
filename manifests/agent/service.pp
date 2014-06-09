# == Class zabbix::agent::service
#
# This class is meant to be called from zabbix
# It ensures the service is running
#
class zabbix::agent::service {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

  service { $zabbix::agent::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
