class puppetfactory::centosimage (
  $puppetmaster,
) {

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
        'puppetmaster' => $puppetmaster,
      }),
    notify  => Docker::Image['centosagent'],
  }

  docker::image { 'centosagent':
    docker_dir => '/var/docker/centosagent/',
    require    => File['/var/docker/centosagent/Dockerfile'],
  }
}
