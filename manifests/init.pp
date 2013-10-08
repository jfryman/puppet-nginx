# Class: nginx
#
# This module manages NGINX.
#
# Parameters:
#
# There are no default parameters for this class. All module parameters are managed
# via the nginx::params class
#
# Actions:
#
# Requires:
#  puppetlabs-stdlib - https://github.com/puppetlabs/puppetlabs-stdlib
#
#  Packaged NGINX
#    - RHEL: EPEL or custom package
#    - Debian/Ubuntu: Default Install or custom package
#    - SuSE: Default Install or custom package
#
#  stdlib
#    - puppetlabs-stdlib module >= 0.1.6
#    - plugin sync enabled to obtain the anchor type
#
# Sample Usage:
#
# The module works with sensible defaults:
#
# node default {
#   include nginx
# }

class nginx (
  $options = $nginx::params::defaults,
  $nginx_vhosts           = {},
  $nginx_upstreams        = {},
  $nginx_locations        = {},
) {

  include stdlib
  include nginx::params

  validate_hash($options)

  $config = merge($nginx::params::defaults, $options)

  class { 'nginx::package':
    package_name   => $package_name,
    package_source => $package_source,
    package_ensure => $package_ensure,
    notify      => Class['nginx::service'],
    manage_repo => $config['manage_repo'],
  }

  class { 'nginx::config':
    options => $config,
  }

  class { 'nginx::service':
    options => $config,
  }

  validate_hash($nginx_upstreams)
  create_resources('nginx::resource::upstream', $nginx_upstreams)
  validate_hash($nginx_vhosts)
  create_resources('nginx::resource::vhost', $nginx_vhosts)
  validate_hash($nginx_locations)
  create_resources('nginx::resource::location', $nginx_locations)

  # Allow the end user to establish relationships to the "main" class
  # and preserve the relationship to the implementation classes through
  # a transitive relationship to the composite class.
  anchor{ 'nginx::begin':
    before => Class['nginx::package'],
    notify => Class['nginx::service'],
  }
  anchor { 'nginx::end':
    require => Class['nginx::service'],
  }
}
