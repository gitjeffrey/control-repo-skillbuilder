## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
# File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

# autostructure

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  if $facts['kernel'] == 'Linux' {
    class { '::ntp':
      servers => [ 'time.nist.gov' ],
    }
  }
}

# simp

# Set the global Exec path to something reasonable
Exec {
  path => [
    '/usr/local/bin',
    '/usr/local/sbin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
  ],
}

# SIMP Scenarios
#
# Set this variable to make use of the different class sets in heiradata/scenarios,
#   mostly applicable to puppet agents, or, the SIMP server overrides some of these.
#   * `simp` - compliant and secure
#   * `simp-lite` - makes use of many of our modules, but doesn't apply
#        many prohibitive security or compliance features, svckill
#   * `poss` - only include pupmod by default to configure the agent
$simp_scenario = 'simp'

# Map SIMP parameters to NIST Special Publication 800-53, Revision 4
# See hieradata/compliance_profiles/ for more options.
$compliance_profile = 'nist_800_53_rev4'

# Place Hiera customizations based on this variable in hieradata/hostgroups/${::hostgroup}.yaml
#
# Example hostgroup declaration using a regex match on the hostname:
#   if $facts['fqdn'] =~ /ws\d+\.<domain>/ {
#     $hostgroup = 'workstations'
#   }
#   else {
#     $hostgroup = 'default'
#   }
#
$hostgroup = 'default'

$testvalue = $::simp_options::puppet::server

warning("${facts['fqdn']}: *** SIMP Open Source *** Test message. [Details: ${testvalue}.]")

notify { 'testmessage1':
  withpath => false,
  message  => "*** SIMP Open Source *** Test message. [Details: ${testvalue}.]",
  loglevel => warning,
}

# Required if you want the SIMP global catalysts
# Defaults should technically be sane in all modules without this
#include '::simp_options'
# Include the SIMP base controller with the preferred scenario
include '::simp'

# Hiera class lookups and inclusions (replaces `hiera_include()`)
$hiera_classes          = lookup('classes',          Array[String], 'unique', [])
$hiera_class_exclusions = lookup('class_exclusions', Array[String], 'unique', [])
$hiera_included_classes = $hiera_classes - $hiera_class_exclusions

include $hiera_included_classes

# For proper functionality, the compliance_markup list needs to be included *absolutely last*
include ::compliance_markup
