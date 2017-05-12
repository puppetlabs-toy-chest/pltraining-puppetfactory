class puppetfactory::centosimage (
  $master_address = $puppetmaster,
) {

  file { '/var/docker':
    ensure => directory,
  }

  # CentOS agent image
  file { '/var/docker/centosagent/':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/puppetfactory/centos/',
    require => Class['docker'],
  }

  file { '/var/docker/centosagent/Dockerfile':
    ensure  => present,
    content => epp('puppetfactory/centos.dockerfile.epp',{
        'puppetmaster' => $master_address,
      }),
    notify  => Docker::Image['centosagent'],
  }

  docker::image { 'centosagent':
    docker_dir => '/var/docker/centosagent/',
  }
}
