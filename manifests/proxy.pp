# == Class: zabbix::proxy
#
# Puppet class to install and configure a Zabbix proxy using SQLite.
#
# === Parameters
#
# [*cachesize*]
#   Size of configuration cache, in bytes.  Shared memory size, for storing
#   hosts and items data.
#   Range: 128K-8G
#   Default: 8M
#
# [*configfrequency*]
#   How often proxy retrieves configuration data from Zabbix Server in seconds.
#   For a proxy in the passive mode this parameter will be ignored.
#   Range: 1-3600*24*7
#   Default: 3600
#
# [*datasenderfrequency*]
#   Proxy will send collected data to the Server every N seconds.
#   For a proxy in the passive mode this parameter will be ignored.
#   Range: 1-3600
#   Default: 1
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
# [*externalscripts*]
#   Full path to location of external scripts.
#   Default: /usr/lib/zabbix/externalscripts
#
# [*heartbeatfrequency*]
#   Frequency of heartbeat messages in seconds; used for monitoring availability
#   of Proxy on server side.  Set to 0 to disable heartbeat messages.
#   For a proxy in the passive mode this parameter will be ignored.
#   Range: 0-3600
#   Default: 60
#
# [*historycachesize*]
#   Size of history cache, in bytes.
#   Shared memory size for storing history data.
#   Range: 128K-2G
#   Default: 8M
#
# [*historytextcachesize*]
#   Size of text history cache, in bytes.
#   Shared memory size for storing character, text or log history data.
#   Range: 128K-2G
#   Default: 16M
#
# [*housekeepingfrequency*]
#   How often Zabbix will perform housekeeping procedure (in hours).
#   Housekeeping is removing unnecessary information from history, alert, and
#   alarms tables.
#   Range: 1-24
#   Default: 1
#
# [*include*]
#   Specify directories or files to include in the Zabbix configuration (ala
#   conf.d style).  Specify as an array if including multiple directories or
#   files.
#   Default: unset
#
# [*javagateway*]
#   IP address (or hostname) of Zabbix Java gateway.
#   Only required if Java pollers are started.
#   Mandatory: no
#   Default: unset
#
# [*javagatewayport*]
#   Port that Zabbix Java gateway listens on.
#   Range: 1024-32767
#   Default: 10052
#
# [*listenip*]
#   IP addresses that the trapper should listen on.  Set as an array to specify
#   multiple IPs.  Trapper will listen on all network interfaces by default.
#   Default: 0.0.0.0
#
# [*listenport*]
#   Listen port for trapper.
#   Range: 1024-32767
#   Default: 10051
#
# [*loadmodule*]
#   Module to load at proxy startup. Modules are used to extend functionality of
#   the proxy.  Specify the filename (module.so) to load the module.  Set as an
#   array to load multiple modules.
#   Default: unset
#
# [*loadmodulepath*]
#   Full path to location of proxy modules.
#   Default: unset
#
# [*logfile*]
#   Location of log file. If not set, syslog is used.
#   Default: unset
#
# [*logfilesize*]
#   Maximum size of log file in MB, set to 0 to disable automatic log rotation. By
#   default this is disabled and the log file is rolled over by the logrotate script.
#   Range: 0-1024
#   Default: 0
#
# [*logslowqueries*]
#   How long in milliseconds a database query may take before being logged as a
#   slow query.  Only works if DebugLevel set to 3 or 4.
#   Range: 1-3600000
#   Default: 0
#
# [*mode*]
#   Proxy operating mode, set to active or passive to set the proxy mode.
#   Default: passive
#
# [*pidfile*]
#   Location of PID file.
#   Default: /var/run/zabbix/zabbix_proxy.pid
#
# [*proxylocalbuffer*]
#   Period in hours that the Proxy will keep data, even if the datah has been
#   synced with the Zabbix Server.  This may be useful if local data will be used
#   by third party applications.
#   Range: 0-720
#   Default: 0
#
# [*proxyofflinebuffer*]
#   Period in hours that the Proxy will keep data for in the event it cannot
#   communicate with the Zabbix Server.  Older data will be be lost.
#   Range: 1-720
#   Default: 1
#
# [*server*]
#   IP address (or hostname) of Zabbix server.  Active proxy will get configuration
#   data from the server.  For a proxy in the passive mode this parameter will be
#   ignored.
#   Default: unset
#
# [*serverport*]
#   Port of Zabbix trapper on Zabbix server.  For a proxy in the passive mode this
#   parameter will be ignored.
#   Range: 1024-32767
#   Default: 10051
#
# [*sourceip*]
#   Source IP address for outgoing connections.
#   Default: unset
#
# [*sshkeylocation*]
#   Location of public and private keys for SSH checks and actions.
#   Mandatory: no
#   Default: unset
#
# [*startdbsyncers*]
#   Number of pre-forked instances of DB Syncers at startup.
#   Range: 1-100
#   Default: 4
#
# [*startdiscoverers*]
#   Number of pre-forked instances of discoverers.
#   Range: 0-250
#   Default: 1
#
# [*starthttppollers*]
#   Number of pre-forked instances of HTTP pollers at startup.
#   Range: 0-1000
#   Default: 1
#
# [*startipmipollers*]
#   Number of pre-forked instances of IPMI pollers at startup.
#   Range: 0-1000
#   Default: 0
#
# [*startjavapollers*]
#   Number of pre-forked instances of Java pollers.
#   Range: 0-1000
#   Default: 0
#
# [*startpingers*]
#   Number of pre-forked instances of ICMP pingers at startup.
#   Range: 0-1000
#   Default: 1
#
# [*startpollers*]
#   Number of pre-forked instances of pollersi at startup.
#   Range: 0-1000
#   Default: 5
#
# [*startpollersunreachable*]
#   Number of pre-forked instances of pollers for unreachable hosts (including IPMI)
#   at startup.
#   Range: 0-1000
#   Default: 1
#
# [*startsnmptrapper*]
#   If set to true, SNMP trapper process is started.
#   Default: false
#
# [*starttrappers*]
#   Number of pre-forked instances of trappers at startup.
#   Trappers accept incoming connections from Zabbix sender and active agents.
#   Range: 0-1000
#   Default: 5
#
# [*startvmwarecollectors*]
#   Number of pre-forked vmware collector instances at startup.
#   Range: 0-250
#   Default: 0
#
# [*timeout*]
#   Specifies how long we wait for agent, SNMP device or external check (in seconds).
#   Range: 1-30
#   Default: 3
#
# [*tmpdir*]
#   Temporary directory.
#   Default: /tmp
#
# [*trappertimeout*]
#   Specifies how many seconds a trapper may spend processing new data.
#   Range: 1-300
#   Default: 300
#
# [*unavailabledelay*]
#   How often host is checked for availability during the unavailability period,
#   in seconds.
#   Range: 1-3600
#   Default: 60
#
# [*unreachabledelay*]
#   How often host is checked for availability during the unreachability period,
#   in seconds.
#   Range: 1-3600
#   Default: 15
#
# [*unreachableperiod*]
#   Period in seconds of unreachability before treating a host as unavailable.
#   Range: 1-3600
#   Default: 45
#
# [*vmwarecachesize*]
#   Size of VMware cache, in bytes.  Shared memory size for storing VMware data.
#   This is only used if VMware collectors are started.
#   Range: 256K-2G
#   Default: 8M
#
# [*vmwarefrequency*]
#   How often Zabbix will connect to VMware service to obtain new data.
#   Range: 10-86400
#   Default: 60
#
class zabbix::proxy (
    $cachesize = '8M',
    $configfrequency = 3600,
    $datasenderfrequency = 1,
    $debuglevel = 'warnings',
    $externalscripts = '/usr/lib/zabbix/externalscripts',
    $heartbeatfrequency = 60,
    $historycachesize = '8M',
    $historytextcachesize = '16M',
    $housekeepingfrequency = 1,
    $include = undef,
    $logslowqueries = 0,
    $javagateway = undef,
    $javagatewayport = 10052,
    $loadmodule = undef,
    $loadmodulepath = undef,
    $listenip = '0.0.0.0',
    $listenport = 10051,
    $logfile = '/var/log/zabbix/zabbix_proxy.log',
    $logfilesize = 0,
    $pidfile = '/var/run/zabbix/zabbix_proxy.pid',
    $proxylocalbuffer = 0,
    $mode = 'passive',
    $proxyofflinebuffer = 1,
    $server = undef,
    $serverport = 10051,
    $sourceip = undef,
    $sshkeylocation = undef,
    $startdbsyncers = 4,
    $startdiscoverers = 1,
    $starthttppollers = 1,
    $startipmipollers = 0,
    $startjavapollers = 0,
    $startpingers = 1,
    $startpollers = 5,
    $startpollersunreachable = 1,
    $startsnmptrapper = false,
    $starttrappers = 5,
    $startvmwarecollectors = 0,
    $tmpdir = '/tmp',
    $timeout = 3,
    $trappertimeout = 300,
    $unavailabledelay = 60,
    $unreachabledelay = 15,
    $unreachableperiod = 45,
    $vmwarecachesize = '8M',
    $vmwarefrequency = 60,
) inherits zabbix::params {

  $conf_file = $zabbix::params::proxy_conf_file
  $package_name = $zabbix::params::proxy_package_name
  $sqlite_file = $zabbix::params::proxy_sqlite_file
  $service_name = $zabbix::params::proxy_service_name

  # validate paths
  validate_absolute_path($externalscripts)
  validate_absolute_path($logfile)
  validate_absolute_path($pidfile)
  validate_absolute_path($tmpdir)

  # validate paths if defined
  if $logfile { validate_absolute_path($logfile) }
  if $loadmodulepath { validate_absolute_path($loadmodulepath) }
  if $sshkeylocation { validate_absolute_path($sshkeylocation) }

  # validate booleans
  validate_bool($startsnmptrapper)

  # validate string regex
  validate_re($debuglevel, '^(none|critical|error|warnings|debug)$',
    '\'$debuglevel\' must be one of \'none\', \'critical\', \'error\', \'warnings\' or \'debug\'')
  validate_re($mode, '^(active|passive)$',
    '\'$mode\' must be one of \'active\' or \'passive\'')

  # validate strings
  validate_string($cachesize)
  validate_string($historycachesize)
  validate_string($historytextcachesize)
  validate_string($javagateway)
  validate_string($listenip)
  validate_string($server)
  validate_string($sourceip)
  validate_string($vmwarecachesize)

  # validate values are between 0 and 250.
  validate_re($startdiscoverers, '^([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|250)$',
    '\'$startdiscoverers\' must be between 0 and 250')
  validate_re($startvmwarecollectors, '^([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|250)$',
    '\'$startvmwarecollectors\' must be between 0 and 250')

  # validate values are between 0 and 720.
  validate_re($proxylocalbuffer, '^([0-9]{1,2}|[1-6][0-9]{2}|7[01][0-9]|720)$',
    '\'$proxylocalbuffer\' must be between 0 and 720')

  # validate values are between 0 and 1000.
  validate_re($starthttppollers, '^([0-9]{1,3}|1000)$',
    '\'$starthttppollers\' must be between 0 and 1000')
  validate_re($startipmipollers, '^([0-9]{1,3}|1000)$',
    '\'$startipmipollers\' must be between 0 and 1000')
  validate_re($startjavapollers, '^([0-9]{1,3}|1000)$',
    '\'$startjavapollers\' must be between 0 and 1000')
  validate_re($startpingers, '^([0-9]{1,3}|1000)$',
    '\'$startpingers\' must be between 0 and 1000')
  validate_re($startpollers, '^([0-9]{1,3}|1000)$',
    '\'$startpollers\' must be between 0 and 1000')
  validate_re($startpollersunreachable, '^([0-9]{1,3}|1000)$',
    '\'$startpollersunreachable\' must be between 0 and 1000')
  validate_re($starttrappers, '^([0-9]{1,3}|1000)$',
    '\'$starttrappers\' must be between 0 and 1000')

  # validate values are between 0 and 1024.
  validate_re($logfilesize, '^([0-9]{1,3}|1024)$',
    '\'$logfilesize\' must be between 0 and 1024')

  # validate values are between 0 and 3600.
  validate_re($heartbeatfrequency, '^([0-9]{1,3}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$heartbeatfrequency\' must be between 0 and 3600')

  # validate values are between 0 and 3600000.
  validate_re($logslowqueries, '^([0-9]{1,5}|[1-5][0-9]{5}|60([0-3][0-9]{3}|4([0-7][0-9]{2}|800)))$',
    '\'$logslowqueries\' must be between 0 and 3600000')

  # validate values are between 1 and 24.
  validate_re($housekeepingfrequency, '^([1-9]|1[0-9]|2[0-4])$',
    '\'$housekeepingfrequency\' must be between 1 and 24')

  # validate values are between 1 and 30.
  validate_re($timeout, '^([1-9]|[12][0-9]|30)$',
    '\'$timeout\' must be between 1 and 30')

  # validate values are between 1 and 100.
  validate_re($startdbsyncers, '^([1-9][0-9]?|100)$',
    '\'$startdbsyncers\' must be between 1 and 100')

  # validate values are between 1 and 300.
  validate_re($trappertimeout, '^([1-9][0-9]?|[12][0-9]{2}|300)$',
    '\'$trappertimeout\' must be between 1 and 300')

  # validate values are between 1 and 720.
  validate_re($proxyofflinebuffer, '^([1-9][0-9]?|[1-6][0-9]{2}|7[01][0-9]|720)$',
    '\'$proxyofflinebuffer\' must be between 1 and 720')

  # validate values are between 1 and 3600.
  validate_re($datasenderfrequency, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$datasenderfrequency\' must be between 1 and 3600')
  validate_re($unavailabledelay, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$unavailabledelay\' must be between 1 and 3600')
  validate_re($unreachabledelay, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$unreachabledelay\' must be between 1 and 3600')
  validate_re($unreachableperiod, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$unreachableperiod\' must be between 1 and 3600')

  # validate values are between 1 and 604800.
  validate_re($configfrequency, '^([1-9][0-9]{0,4}|[1-5][0-9]{5}|60([0-3][0-9]{3}|4([0-7][0-9]{2}|800)))$',
    '\'$configfrequency\' must be between 1 and 604800')

  # validate values are between 10 and 86400.
  validate_re($vmwarefrequency, '^([1-9][0-9]{1,3}|[1-7][0-9]{4}|8[0-5][0-9]{3}|86[0-3][0-9]{2}|86400)$',
    '\'$vmwarefrequency\' must be between 10 and 86400')

  # validate values are between 1024 and 32767.
  validate_re($javagatewayport, '^(102[4-9]|10[3-9][0-9]|1[1-9][0-9]{2}|[2-9][0-9]{3}|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$',
    '\'$javagatewayport\' must be between 1024 and 32767')
  validate_re($listenport, '^(102[4-9]|10[3-9][0-9]|1[1-9][0-9]{2}|[2-9][0-9]{3}|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$',
    '\'$listenport\' must be between 1024 and 32767')
  validate_re($serverport, '^(102[4-9]|10[3-9][0-9]|1[1-9][0-9]{2}|[2-9][0-9]{3}|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$',
    '\'$serverport\' must be between 1024 and 32767')

  class { 'zabbix::proxy::install': } ->
  class { 'zabbix::proxy::config': } ~>
  class { 'zabbix::proxy::service': } ->
  Class['zabbix::proxy']
}
