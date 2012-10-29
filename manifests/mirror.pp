# -*- mode: puppet -*-
# vi: set ft=puppet :

class mirror {
  package {
    'apt-mirror':
      ensure => latest;
  }

  exec {
    'apt-mirror-list':
      command => '/vagrant/apt-mirror-list > /etc/apt/mirror.list';
  }

  file {
    '/etc/apt/mirror.list':
      ensure  => present,
      require => Exec['apt-mirror-list'];

    '/home/vagrant/apt-mirror-index':
      ensure  => present,
      source  => 'file:///vagrant/apt-mirror-index',
      owner   => 'vagrant',
      group   => 'vagrant',
      mode    => 0755;
  }

  exec {
    'apt-mirror-index':
      command => '/usr/bin/sudo -H -u apt-mirror -s /home/vagrant/apt-mirror-index',
      require => [
        File['/etc/apt/mirror.list'],
        File['/home/vagrant/apt-mirror-index']
      ];
  }
}

include mirror
