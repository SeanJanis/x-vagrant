host {
  'local.pd':
    ip => '127.0.0.1'
}

# Lets tell Puppet the order of our stages
stage { 
  'users':      before => Stage['repos'];
  'repos':      before => Stage['updates'];
  'updates':    before => Stage['tools'];
  'tools':      before => Stage['packages'];
  'packages':   before => Stage['configure'];
  'configure':  before => Stage['services'];
  'services':   before => Stage['main'];
}

class tools {
  package {
    "git":
      ensure => latest;

    "vim":
      ensure => latest;

    "vim-common":
      ensure => latest;

    "curl":
      ensure => present;

    "htop":
      ensure => present;
  }
}
 
class services {
  # Ensure these services are running when server boots
  service { 
    'mongodb':
      ensure => running,
      enable => true;
  }
}
 
class configure {
  # Add any custom stuff here please
}
 
class packages {
  include apt

  apt::ppa {
    'ppa:chris-lea/node.js': notify => Package["nodejs"]
  }

  package {
    "mongodb-10gen":
      ensure => "present";

    "nodejs" :
      ensure => latest;

    "redis-server":
      ensure => latest;
  }

  exec { "npm-update" :
    cwd => "/vagrant",
    command => "npm -g update",
    onlyif => ["test -d /vag rant/node_modules"],
    path => ["/bin", "/usr/bin"],
    require => Package['nodejs']
  }
}
 
class updates {
  # We must run apt-get update before we install our packaged because we installed some repo's
  exec {
    "apt-update":
      command => "/usr/bin/apt-get update -y -q",
      timeout => 0
  }
}
 
class repos {
  #lets install some repos
  exec { 
    "get-mongo-key" :
      command => "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
      unless  => "/usr/bin/apt-key list| /bin/grep -c 10gen";
    "install-mongo-repo":
      command => "/bin/echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' >> /etc/apt/sources.list",
      unless  => "/bin/grep 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart' -c /etc/apt/sources.list";
  }
}
 
class users {
  group { "puppet":
    ensure => "present",
  }
}
 
class { 
  users:      stage => "users";
  repos:      stage => "repos";
  updates:    stage => "updates";
  tools:      stage => "tools";
  packages:   stage => "packages";
  configure:  stage => "configure";
  services:   stage => "services";
}