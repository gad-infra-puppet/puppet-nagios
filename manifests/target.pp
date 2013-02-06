#
# Class: nagios::target
#
# Basic host target class
# Include it on nodes to be monitored by nagios
#
# Usage:
# include nagios::target
#
class nagios::target ($hostgroups = false, $use_hostname = false) {

  # This variable defines where nagios automatically generated 
  # files are places. This MUST be the same of $::nagios::customconfigdir
  # HINT: Do not mess with default path names...

  $customconfigdir = $nagios::customconfigdir ? {
    ''      => '/etc/nagios3/auto.d',
    default => $nagios::customconfigdir,
  }

  # TODO: Find a smarter solution that doesn't requre TopScope Variables
  $magic_tag = get_magicvar($::nagios_grouplogic)
  
  if $use_hostname {
    $host_name = $hostname
  } else {
    $host_name = $fqdn
  } 

  if hostgroups {
    nagios::host { $host_name: 
      use        => 'generic-host',
      hostgroups => $hostgroups,
    }
  } else {
    nagios::host { $host_name: 
      use => 'generic-host',
    }
  }

  nagios::baseservices { $host_name:
    use => 'generic-service',
    host_name => $host_name,
  }

  include nagios::plugins

# TODO: Automatic hostgroup management is broken. We'll review it later
#  nagios::hostgroup { "${nagios::params::hostgroups}-$fqdn": 
#    hostgroup => "${nagios::params::hostgroups}",
#  }

}
