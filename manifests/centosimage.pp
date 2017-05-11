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

  # Mount the mirror directory because docker doesn't follow symlinks
  # mount --bind /var/yum/mirror mirror
  file {'/var/docker/centosagent/mirror':
    ensure => directory,
    before => Mount['/var/docker/centosagent/mirror'],
  }

  mount {'/var/docker/centosagent/mirror':
    ensure  => mounted,
    atboot  => true,
    device  => '/var/yum/mirror',
    fstype  => 'xfs',
    options => 'bind',
    before  => Docker::Image['centosagent']
  }

  # Mount the gem cache directory because docker doesn't follow symlinks
  # mount --bind /var/cache/rubygems rubygems
  file {'/var/docker/centosagent/rubygems':
    ensure => directory,
    before => Mount['/var/docker/centosagent/rubygems'],
  }

  mount {'/var/docker/centosagent/rubygems':
    ensure  => mounted,
    atboot  => true,
    device  => '/var/cache/rubygems',
    fstype  => 'xfs',
    options => 'bind',
    before  => Docker::Image['centosagent']
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

