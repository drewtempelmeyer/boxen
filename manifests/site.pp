require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # default ruby versions
  include ruby::1_9_3
  include ruby::2_0_0

  # Text editor
  include macvim

  # Go
  include go::1_1_1

  # Java
  include java

  # PhantomJS
  include phantomjs

  # Postgres.app
  include postgresapp

  # Redis
  include redis

  # Sequel Pro
  include sequel_pro

  # iTerm 2
  include iterm2::stable

  # zsh
  include zsh

  # autojump
  include autojump

  # Pow
  include pow

  # Alfred
  include alfred

  # Browsers
  include chrome
  include firefox

  # Vagrant
  include vagrant

  # Virtualbox
  include virtualbox

  # Packages installed via homebrew
  package {
    [
      'imagemagick',
      'heroku-toolbelt',
      'mariadb',
      'rbenv-gem-rehash',
      'readline',
      'scala',
      'sbt',
      'play',
      'ctags'
    ]:
  }

  # OS Customizations
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
  include osx::dock::autohide
  include osx::finder::empty_trash_securely
  include osx::software_update
  include osx::no_network_dsstores

  class { 'osx::dock::icon_size':
    size => 26
  }

  #### Additional Goodies

  # Spotify
  include spotify

  # common, useful packages
  package {
    [
      'the_silver_searcher',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
