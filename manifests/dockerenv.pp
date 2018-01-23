class puppetfactory::dockerenv {
  assert_private('This class should not be called directly')
  class { 'docker':
    extra_parameters => '--default-ulimit nofile=1000000:1000000',
  }
  file {'/etc/security/limits.conf':
    ensure => file,
    source => 'puppet:///modules/puppetfactory/limits.conf',
    before => Class['docker'],
  }

  sysctl {'net.ipv4.ip_forward':
    ensure    => present,
    value     => '1',
    permanent => 'yes',
  }

  # See https://jhutar.blogspot.cz/2017/12/error-too-many-open-files-when-inside.html
  sysctl {'fs.inotify.max_user_instances':
    ensure    => present,
    value     => '8192',
    permanent => 'yes',
  }
  sysctl {'fs.inotify.max_user_watches':
    ensure    => present,
    value     => '1048576',
    permanent => 'yes',
  }

  file { '/var/run/docker.sock':
    group   => $puppetfactory::docker_group,
    mode    => '0664',
    require => [Class['docker'],Group['docker']],
  }

  group { $puppetfactory::docker_group:
    ensure => present,
  }

  file { '/var/docker':
    ensure => directory,
  }

  class { [ 'puppetfactory::ubuntuimage']:
    puppetmaster => pick($puppetfactory::master, $servername),
  }
  class { 'dockeragent':
    image_name => 'centosagent',
  }

}
