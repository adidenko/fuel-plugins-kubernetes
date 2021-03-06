# Class: plugin_k8s::kubelet
# ===========================
#
# This class installs and configures kubelet
#
# Parameters
# ----------
#
#
# Variables
# ----------
#
#
# Examples
# --------
#
# @example
#    include ::plugin_k8s::kubelet
#
class plugin_k8s::kubelet {
  notice('MODULAR: kubernetes/kubelet.pp')

  include ::plugin_k8s::params

  # Kubernetes needs nsenter in order to find out container's IP, nsenter is
  # a part of util-linux starting from version 2.24, so Ubuntu 14.10 and
  # newer are OK
  if $::operatingsystem == 'ubuntu' and $::operatingsystemrelease == '14.04' {
    package {'nsenter':
      ensure => installed,
    }
  }

  class { '::kubernetes::kubelet':
    bind_address       => $::plugin_k8s::params::bind_address,
    api_servers        => $::plugin_k8s::params::api_vip_url,
    cluster_dns        => $::plugin_k8s::params::dns_server,
    cluster_domain     => $::plugin_k8s::params::dns_domain,
    node_name          => $::plugin_k8s::params::node_name,
    network_plugin     => $::plugin_k8s::params::network_plugin,
    network_plugin_dir => $::plugin_k8s::params::network_plugin_dir,
  }

  firewall { '404 kubelet':
    dport  => [ '10250', '10255', ],
    proto  => 'tcp',
    action => 'accept',
    tag    => [ 'kubernetes', 'kubelet', ],
  }
}
