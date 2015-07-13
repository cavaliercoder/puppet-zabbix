# private computed global parameters
class zabbix::params inherits zabbix::globals {
  # OS distrelease.
  # This will be 5 or 6 on RedHat, 6 or wheezy on Debian, 12 or quantal on Ubuntu, etc.
  $osr_array = split($::operatingsystemrelease,'[\/\.]')
  $distrelease = $osr_array[0]
  if ! $distrelease {
    fail("Class['apache::version']: Unparsable \$::operatingsystemrelease: ${::operatingsystemrelease}")
  }

  # version
  $version = pick($version, '2.2.9')
  $version_parts = split($version, '[.]')
  $ver_major = $version_parts[0]
  $ver_minor = $version_parts[1]
  $ver_patch = $version_parts[2]
  $ver_release = '1'

  $repo_version = "${ver_major}.${ver_minor}"
  $package_version = "${ver_major}.${ver_minor}.${ver_patch}-${ver_release}.el${distrelease}"

  # yum repo
  $repo_url = pick($repo_url, "http://repo.zabbix.com/zabbix/${repo_version}/rhel/${distrelease}/${architecture}/")
  $ns_repo_url = pick($ns_repo_url, "http://repo.zabbix.com/non-supported/rhel/${distrelease}/${architecture}/")
  $repo_gpgkey = pick($repo_gpgkey, 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX')

  # database connection
  $install_db_client = pick($install_db_client, false)
  $dbengine = pick($dbengine, 'pgsql')
  $dbhost = pick($dbhost, 'localhost')
  $dbschema = pick($dbschema, 'public')
  $dbname = pick($dbname, 'zabbix')
  $dbuser = pick($dbuser, 'zabbix')
  $dbpasswd = pick($dbpasswd, 'zabbix')
  $dbport = pick($dbport, 5432)

  $dbadmin = pick($dbadmin, 'postgres')
  $dbadmin_db = pick($dbadmin_db, $dbadmin)

  $pgscripts = "/usr/share/doc/zabbix-server-pgsql-${ver_major}.${ver_minor}.${ver_patch}/create"

  # server common
  $server = pick($server, 'localhost')
  $server_name = "Zabbix ${::environment}"
  $server_service = 'zabbix-server'
  $server_user = 'zabbix'
  $server_group = 'zabbix'

  $server_port = pick($server_port, 10051)
  $server_config_file = '/etc/zabbix/zabbix_server.conf'
  $server_config_owner = 'root'
  $server_config_group = $server_group
  $server_config_mode = '0640'

  # web server common
  $web_config_file = '/etc/zabbix/web/zabbix.conf.php'
  $web_config_file_mode = '640'
  $web_user = 'apache'
  $web_group = 'apache'
  $timezone = pick($timezone, 'Australia/Perth')
  $http_port = 80
  $docroot = '/usr/share/zabbix'

  case $dbengine {
    'pgsql': {
      $web_db_driver = 'POSTGRESQL'
    }

    default : { fail("Unsupported db engine: ${dbengine}") }
  }

  # LDAP auth integration
  $ldap_host = undef
  $ldap_port = 389
  $ldap_base_dn = undef
  $ldap_bind_dn = undef
  $ldap_bind_pwd = undef
  $ldap_user = undef
  $ldap_search_att = 'sAMAccountName'

  # agent
  $agent_package = 'zabbix-agent'
  $agent_service = 'zabbix-agent'  
  $agent_user    = $server_user
  $agent_group   = $server_group

  # agent config
  $agent_config_file = '/etc/zabbix/zabbix_agentd.conf'
  $agent_config_owner = 'root'
  $agent_config_group = 'root'
  $agent_config_mode = '0644'
}