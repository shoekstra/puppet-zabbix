# == Class: zabbix::repo
#
# Installs official Zabbix repository.
#
# === Parameters
#
# [*version*]
#   Specify Zabbix version.  This can be either 2.0 or 2.2, defaults to 2.2.
#
class zabbix::repo (
    $version = '2.2'
) {

  validate_re($version, '^(2\.0|2\.2)$', 'version must be either 2.0 or 2.2')

  $os_downcase = downcase($::operatingsystem)

  if $::operatingsystem =~ /^(Debian|Ubuntu)$/ {
    apt::source { 'zabbix':
      location    => "http://repo.zabbix.com/zabbix/${::zabbix::repo::version}/${os_downcase}/",
      release     => $::lsbdistcodename,
      repos       => 'main',
      key         => '79EA5ED4',
      key_source  => 'http://repo.zabbix.com/zabbix-official-repo.key',
      include_src => false
    }
  }

  if $::operatingsystem =~ /^(Centos|Redhat)$/ {
    yumrepo { 'zabbix':
      baseurl  => "http://repo.zabbix.com/zabbix/${::zabbix::repo::version}/rhel/",
      gpgcheck => '1',
      gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
    }
  }
}
