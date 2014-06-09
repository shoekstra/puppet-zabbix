# == Class: zabbix::server
#
# Puppet class to install and configure a Zabbix server.
#
# === Parameters
#
# [*alertscriptspath*]
#   Full path to location of custom alert scripts.
#   Default: /usr/lib/zabbix/alertscripts
#
# [*cachesize*]
#   Size of configuration cache, in bytes.  Shared memory size, for storing
#   hosts and items data.
#   Range: 128K-8G
#   Default: 8M
#
# [*cacheupdatefrequency*]
#   How often Zabbix will perform update of configuration cache, in seconds.
#   Range: 1-3600
#   Default: 60
#
# [*dbhost*]
#   Database host name.
#   If set to localhost, socket is used for MySQL.
#   If set to empty string, socket is used for PostgreSQL.
#   Default: localhost
#
# [*dbname*]
#   Database name.
#   Default: zabbix
#
# [*dbuser*]
#   Database user. 
#   Default: zabbix
#
# [*dbpass*]
#   Database password.  Highly recommended to change this form the default.
#   Default: zabbix
#
# [dbsocket*]
#   Path to MySQL socket.
#   Default: /var/run/mysqld/mysqld.sock
#
# [*dbport*]
#   Database port when not using local socket. Ignored for SQLite.
#   Range: 1024-65535
#   Default (for MySQL): 3306
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
# [*historycachesize*]
#   Size of history cache, in bytes.  Shared memory size for storing history
#   data.
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
#   Specify directories or files to include in the Zabbix configuration (ala conf.d 
#   style).  Specify as an array if including multiple directories or files.
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
# [*maxhousekeeperdelete*]
#   No more than 'MaxHousekeeperDelete' rows will be deleted per one task in one 
#   housekeeping cycle.  If set to 0 then no limit is used at all. In this case you 
#   must know what you are doing!
#   Range: 0-1000000
#   Default: 500
#   MaxHousekeeperDelete=500
#
# [*nodenoevents*]
#   If set to true local events won't be sent to master node.
#   This won't impact ability of this node to propagate events from its child nodes.
#   Default: false
#
# [*nodenohistory*]
#   If set to true local history won't be sent to master node.
#   This won't impact ability of this node to propagate history from its child nodes.
#   Default: false
#
# [*pidfile*]
#   Location of PID file.
#   Default: /var/run/zabbix/zabbix_server.pid
#
# [*proxyconfigfrequency*]
#   How often Zabbix Server sends configuration data to a Zabbix Proxy in seconds.
#   This parameter is used only for proxies in the passive mode.
#   Range: 1-3600*24*7
#   Default: 3600
#
# [*proxydatafrequency*]
#   How often Zabbix Server requests history data from a Zabbix Proxy in seconds.
#   This parameter is used only for proxies in the passive mode.
#   Range: 1-3600
#   Default: 1
#
# [*senderfrequency*]
#   How often Zabbix will try to send unsent alerts (in seconds).
#   Range: 5-3600
#   Default: 30
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
# [*startproxypollers]
#   Number of pre-forked instances of pollers for passive proxies.
#   Range: 0-250
#   Default: 1
#
# [*startsnmptrapper*]
#   If set to true, SNMP trapper process is started.
#   Default: false
#
# [*starttimers*]
#   Number of pre-forked instances of timers.
#   Timers process time-based trigger functions and maintenance periods.
#   Only the first timer process handles the maintenance periods.
#   Range: 1-1000
#   Default: 1
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
# [*tmpdir*]
#   Temporary directory.
#   Default: /tmp
#
# [*timeout*]
#   Specifies how long we wait for agent, SNMP device or external check (in seconds).
#   Range: 1-30
#   Default: 3
#
# [*trappertimeout*]
#   Specifies how many seconds a trapper may spend processing new data.
#   Range: 1-300
#   Default: 300
#
# [*trendcachesize*]
#   Size of trend cache, in bytes.  Shared memory size for storing trends data.
#   Range: 128K-2G
#   Default: 4M
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
# [*valuecachesize*]
#   Size of history value cache, in bytes.  Shared memory size for caching 
#   item history data requests.  Setting to 0 disables value cache.
#   Range: 0,128K-64G
#   ValueCacheSize=8M
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
class zabbix::server (
    $alertscriptspath = '/usr/lib/zabbix/alertscripts',
    $cachesize = '8M',
    $cacheupdatefrequency = 60,
    $dbhost = 'localhost',
    $dbname = 'zabbix',
    $dbpass = 'zabbix',
    $dbport = 3306,
    $dbsocket = '/var/run/mysqld/mysqld.sock',
    $dbuser = 'zabbix',
    $debuglevel = 'warnings',
    $externalscripts = '/usr/lib/zabbix/externalscripts',
    $historycachesize = '8M',
    $historytextcachesize = '16M',
    $housekeepingfrequency = 1,
    $include = undef,
    $javagateway = undef,
    $javagatewayport = 10052,
    $listenip = '0.0.0.0',
    $listenport = 10051,
    $loadmodule = undef,
    $loadmodulepath = undef,
    $logfile = '/var/log/zabbix/zabbix_server.log',
    $logfilesize = 0,
    $logslowqueries = 0,
    $maxhousekeeperdelete = 500,
    $nodenoevents = false,
    $nodenohistory = false,
    $pidfile = '/var/run/zabbix/zabbix_server.pid',
    $proxyconfigfrequency = 3600,
    $proxydatafrequency = 1,
    $senderfrequency = 30,
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
    $startproxypollers = 1,
    $startsnmptrapper = false,
    $starttimers = 1,
    $starttrappers = 5,
    $startvmwarecollectors = 0,
    $tmpdir = '/tmp',
    $timeout = 3,
    $trappertimeout = 300,
    $trendcachesize = '4M',
    $unavailabledelay = 60,
    $unreachabledelay = 15,
    $unreachableperiod = 45,
    $valuecachesize = '8M',
    $vmwarecachesize = '8M',
    $vmwarefrequency = 60,
) inherits zabbix::params {

  # validate paths
  validate_absolute_path($alertscriptspath)
  validate_absolute_path($externalscripts)
  validate_absolute_path($pidfile)
  validate_absolute_path($tmpdir)

  # validate paths if defined
  if $logfile { validate_absolute_path($logfile) }
  if $loadmodulepath { validate_absolute_path($loadmodulepath) }
  if $sshkeylocation { validate_absolute_path($sshkeylocation) }

  # validate booleans
  validate_bool($nodenoevents)
  validate_bool($nodenohistory)
  validate_bool($startsnmptrapper)

  # validate strings
  validate_string($cachesize)
  validate_string($dbhost)
  validate_string($dbname)
  validate_string($dbuser)
  validate_string($historycachesize)
  validate_string($historytextcachesize)
  validate_string($javagateway)
  validate_string($listenip)
  validate_string($sourceip)
  validate_string($trendcachesize)
  validate_string($valuecachesize)
  validate_string($vmwarecachesize)

  # validate string regex
  validate_re($debuglevel, '^(none|critical|error|warnings|debug)$',
    '\'$debuglevel\' must be one of \'none\', \'critical\', \'error\', \'warnings\' or \'debug\'')

  # validate values are between 0 and 250.
  validate_re($startdiscoverers, '^([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|250)$',
    '\'$startdiscoverers\' must be between 0 and 250')
  validate_re($startproxypollers, '^([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|250)$',
    '\'$startproxypollers\' must be between 0 and 250')
  validate_re($startvmwarecollectors, '^([0-9]{1,2}|1[0-9]{2}|2[0-4][0-9]|250)$',
    '\'$startvmwarecollectors\' must be between 0 and 250')

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

  # validate values are between 1 and 1000.
  validate_re($starttimers, '^([1-9][0-9]{0,2}|1000)$',
    '\'$starttimers\' must be between 1 and 1000')

  # validate values are between 1 and 3600.
  validate_re($cacheupdatefrequency, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$cacheupdatefrequency\' must be between 1 and 3600')
  validate_re($proxydatafrequency, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$proxydatafrequency\' must be between 1 and 3600')
  validate_re($unavailabledelay, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$unavailabledelay\' must be between 1 and 3600')
  validate_re($unreachabledelay, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$unreachabledelay\' must be between 1 and 3600')
  validate_re($unreachableperiod, '^([1-9][0-9]{0,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$unreachableperiod\' must be between 1 and 3600')

  # validate values are between 1 and 604800.
  validate_re($proxyconfigfrequency, '^([1-9][0-9]{0,4}|[1-5][0-9]{5}|60([0-3][0-9]{3}|4([0-7][0-9]{2}|800)))$',
    '\'$proxyconfigfrequency\' must be between 1 and 604800')

  # validate values are between 1 and 1000000.
  validate_re($maxhousekeeperdelete, '^([0-9]{1,6}|1000000)$',
    '\'$maxhousekeeperdelete\' must be between 1 and 1000000')

  # validate values are between 5 and 3600.
  validate_re($senderfrequency, '^([5-9]|[1-9][0-9]{1,2}|[12][0-9]{3}|3[0-5][0-9]{2}|3600)$',
    '\'$senderfrequency\' must be between 5 and 3600')

  # validate values are between 10 and 86400.
  validate_re($vmwarefrequency, '^([1-9][0-9]{1,3}|[1-7][0-9]{4}|8[0-5][0-9]{3}|86[0-3][0-9]{2}|86400)$',
    '\'$vmwarefrequency\' must be between 10 and 86400')

  # validate values are between 1024 and 32767.
  validate_re($javagatewayport, '^(102[4-9]|10[3-9][0-9]|1[1-9][0-9]{2}|[2-9][0-9]{3}|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$',
    '\'$javagatewayport\' must be between 1024 and 32767')
  validate_re($listenport, '^(102[4-9]|10[3-9][0-9]|1[1-9][0-9]{2}|[2-9][0-9]{3}|[12][0-9]{4}|3[01][0-9]{3}|32[0-6][0-9]{2}|327[0-5][0-9]|3276[0-7])$',
    '\'$listenport\' must be between 1024 and 32767')

  # validate values are between 1024 and 65535.
  validate_re($dbport, '^(102[4-9]|10[3-9][0-9]|1[1-9][0-9]{2}|[2-9][0-9]{3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$',
    '\'$dbport\' must be between 1024 and 65535')

  $conf_file = $zabbix::params::server_conf_file
  $package_name = $zabbix::params::server_package_name
  $service_name = $zabbix::params::server_service_name

  class { 'zabbix::server::install': } ->
  class { 'zabbix::server::config': } ~>
  class { 'zabbix::server::service': } ->
  Class['zabbix::server']
}
