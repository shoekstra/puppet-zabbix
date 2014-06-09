# == Class zabbix::agent::config
#
# This class is called from zabbix
#
class zabbix::agent::config {
  if $caller_module_name != $module_name { fail("Use of private class ${name} by ${caller_module_name}") }

#  $agent_config_template = $::osfamily ? {
#    windows => "zabbix/agent/${zabbix::agent::version}/zabbix_agentd.win.conf.erb",
#    default => "zabbix/agent/${zabbix::agent::version}/zabbix_agentd.conf.erb"
#  }
#

  file { $zabbix::agent::conf_file:
    ensure  => present,
    mode    => 0644,
    owner   => 'root',
    group   => 'root',
    content => template('zabbix/zabbix_agentd.conf.erb'),
  }
}
