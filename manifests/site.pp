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

  # Go
  include go::1_1_1

  # Java
  include java

  # PhantomJS
  include phantomjs

  # Postgres.app
  include postgresapp

  # MySQL
  include mysql

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

  # Text editor
  include macvim

  # maximum-awesome
  class { 'maximumawesome':
    repo => 'drewtempelmeyer/vimfiles'
  }

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

  # Dropbox
  include dropbox

  # Steam
  include steam

  # Packages installed via homebrew
  package {
    [
      'imagemagick',
      'heroku-toolbelt',
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

  # Add/remove applications to the Dock
  include dockutil

  dockutil::item { 'Add iTerm':
    item     => '/Applications/iTerm.app',
    label    => 'iTerm',
    action   => 'add',
    position => 2,
  }

  dockutil::item { 'Add MacVim':
    item     => '/Applications/MacVim.app',
    label    => 'MacVim',
    action   => 'add',
    position => 3,
  }

  dockutil::item { 'Remove Notes':
    item     => '/Applications/Notes.app',
    label    => 'Notes',
    action   => 'remove'
  }

  dockutil::item { 'Remove Photo Booth':
    item     => '/Applications/Photo Booth.app',
    label    => 'Photo Booth',
    action   => 'remove'
  }

  dockutil::item { 'Remove Mission Control':
    item     => '/Applications/Mission Control.app',
    label    => 'Mission Control',
    action   => 'remove'
  }

  dockutil::item { 'Remove Launchpad':
    item     => '/Applications/Launchpad.app',
    label    => 'Launchpad',
    action   => 'remove'
  }

  dockutil::item { 'Remove Contacts':
    item     => '/Applications/Contacts.app',
    label    => 'Contacts',
    action   => 'remove'
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

  file { "${::boxen_home}/Library/Fonts/Anonymice-Powerline.ttf":
    ensure => present,
    source => "file://${::boxen_repodir}/files/fonts/Anonymice-Powerline.ttf"
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
