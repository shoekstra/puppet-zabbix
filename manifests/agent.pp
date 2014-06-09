# == Class: zabbix::agent
#
# Pupepet class to install and configure a Zabbix agent.
#
# === Parameters
#
# [*allowunsafeuserparameters*]
#   If set to true, allow all characters to be passed in arguments to user-defined
#   parameters.
#   Default: false
#
# [*buffersend*]
#   Do not keep data longer than N seconds in buffer.
#   Range: 1-3600
#   Default: 5
#
# [*buffersize*]
#   Maximum number of values in a memory buffer. The agent will send all collected
#   data to Zabbix Server or Proxy if the buffer is full.
#   Range: 2-65535
#   Default: 100
#
# [*debuglevel*]
#   Specifies debug level, possible options are:
#     - none
#     - critical
#     - error
#     - warnings
#     - debug (produces lots of information)
#   Default: warnings
#
# [*enableremotecommands*]
#   If set to true, remote commands from Zabbix server are allowed.
#   Default: false
#
# [*listenip*]
#   IP addresses that the trapper should listen on.  Set as an array to specify
#   multiple IPs.  Trapper will listen on all network interfaces by default.
#   Default: 0.0.0.0
#
# [*listenport*]
#   Listen port for trapper.
#   Range: 1024-32767
#   Default: 10050
#
# [*logfile*]
#   Location of log file. If not set, syslog is used.
#   Default: /var/log/zabbix-agent/zabbix_agentd.log
#
# [*logfilesize*]
#   Maximum size of log file in MB, set to 0 to disable automatic log rotation. By
#   default this is disabled and the log file is rolled over by the logrotate script.
#   Range: 0-1024
#   Default: 0
#
# [*logremotecommands*]
#   If set to true, logging of executed shell commands are logged as warnings.
#   Default: false
#
# [*maxlinespersecond*]
#   Maximum number of new lines the agent will send per second to Zabbix Server or
#   Proxy processing 'log' and 'logrt' active checks.  The provided value will be
#   overridden by the parameter 'maxlines' provided in 'log' or 'logrt' item keys.
#   Range: 1-1000
#   Default: 100
#
# [*pidfile*]
#   Location of PID file.
#   Default: /var/run/zabbix/zabbix_agentd.pid
#
# [*refreshactivechecks*]
#   How often list of active checks is refreshed, in seconds.
#   Range: 60-3600
#   Default: 120
#
# [*server*]
#   List of IP addresses (or hostnames) of Zabbix servers.  First entry is used for
#   receiving list of and sending active checks.
#   Default: unset
#
# [*sourceip*]
#   Source IP address for outgoing connections.
#   Default: unset
#
# [*startagents*]
#   Number of pre-forked instances of zabbix_agentd that process passive checks.
#   Range: 1-100
#   Default: 3
#
# [*timeout*]
#   Specifies how long we wait for agent, SNMP device or external check (in seconds).
#   Range: 1-30
#   Default: 3
#
class zabbix::agent (
    $server,
    $allowunsafeuserparameters = false,
    $buffersend = 5,
    $buffersize = 100,
    $debuglevel = 'warnings',
    $disableactive = false,
    $disablepassive = false,
    $enableremotecommands = false,
    $listenip = '0.0.0.0',
    $listenport = 10050,
    $logfile = '/var/log/zabbix-agent/zabbix_agentd.log',
    $logfilesize = 0,
    $logremotecommands = false,
    $maxlinespersecond = 100,
    $pidfile = '/var/run/zabbix/zabbix_agentd.pid',
    $refreshactivechecks = 120,
    $sourceip = undef,
    $startagents = 3,
    $timeout = 3,
) inherits zabbix::params {

  # validate paths
  validate_absolute_path($pidfile)

  # validate paths if defined
  if $logfile { validate_absolute_path($logfile) }

  # validate booleans
  validate_bool($allowunsafeuserparameters)
  validate_bool($disableactive)
  validate_bool($disablepassive)
  validate_bool($enableremotecommands)
  validate_bool($logremotecommands)

  # validate strings
  validate_string($listenip)
  validate_string($sourceip)

  # validate string regex
  validate_re($debuglevel, '^(none|critical|error|warnings|debug)$',
    '\'$debuglevel\' must be one of \'none\', \'critical\', \'error\', \'warnings\' or \'debug\'')

  # validate values are between 0 and 1024.
  validate_re($logfilesize, '^([0-9]{1,3}|1024)$',
    '\'$logfilesize\' must be between 0 and 1024')

  # validate values are between 1 and 30.
  validate_re($timeout, '^([1-9]|[12][0-9]|30)$',
    '\'$timeout\' must be between 1 and 30')

  # validate values are between 1 and 100.
  validate_re($startagents, '^([1-9][0-9]?|100)$',
    '\'$startagents\' must be between 1 and 100')

  # validate values are between 1 and 1000.
  validate_re($maxlinespersecond, '^([1-9][0-9]{0,2}|1000)$',
    '\'$maxlinespersecond\' must be between 1 and 1000')

  # validate values are between 1 and 3600.
  validate_re($buffersend, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$buffersend\' must be between 1 and 3600')

  # validate values are between 2 and 65535.
  validate_re($buffersize, '^([2-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$',
    '\'$buffersize\' must be between 2 and 65535')

  # validate values are between 60 and 3600.
  validate_re($refreshactivechecks, '^([6-9][0-9]|[1-9][0-9]{2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$refreshactivechecks\' must be between 60 and 3600')

  # validate values are between 1024 and 32767.
  validate_re($listenport, '^(102[4-9]|10[3-9][0-9]|1[1-9][0-9]{2}|[2-9][0-9]{3}|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$',
    '\'$listenport\' must be between 1024 and 32767')

  $conf_file = $zabbix::params::agent_conf_file
  $include_dir = $zabbix::params::agent_include_dir
  $package_name = $zabbix::params::agent_package_name
  $service_name = $zabbix::params::agent_service_name

  class { 'zabbix::agent::install': } ->
  class { 'zabbix::agent::config': } ~>
  class { 'zabbix::agent::service': } ->
  Class['zabbix::agent']
}
