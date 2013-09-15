# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

def github(name, version, options = nil)
  options ||= {}
  options[:repo] ||= "boxen/puppet-#{name}"
  mod name, version, :github_tarball => options[:repo]
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen",      "3.0.2"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "autoconf",   "1.0.0"
github "dnsmasq",    "1.0.0"
github "gcc",        "2.0.1"
github "git",        "1.2.5"
github "homebrew",   "1.4.1"
github "inifile",    "1.0.0", :repo => "puppetlabs/puppetlabs-inifile"
github "nodejs",     "3.2.9"
github "openssl",    "1.0.0"
github "repository", "2.2.0"
github "ruby",       "6.3.4"
github "stdlib",     "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",       "1.0.0"
github "xquartz",    "1.1.0"
github "go",         "1.0.1"
github "alfred",     "1.1.3"
github "chrome",     "1.1.1"
github "firefox",    "1.1.3"
github "java",       "1.1.2"
github "macvim",     "1.0.0"
github "osx",        "1.6.0"
github "iterm2",     "1.0.3"
github "pow",        "1.0.0"
github "autojump",   "1.0.0"
github "phantomjs",  "2.0.2"
github "postgresapp", "1.0.0"
github "mysql",      "1.1.5"
github "redis",      "1.0.0"
github "sequel_pro", "1.0.0"
github "heroku",     "2.0.0"
github "spotify",    "1.0.1"
github "vagrant",    "2.0.11"
github "virtualbox", "1.0.5"
github "zsh",        "1.0.0"
github "dropbox",    "1.1.1"
github "steam",      "1.0.1"
github "mou",        "1.1.3"

mod "property_list_key", "0.1.0"

mod "ohmyzsh", "1.0.0", :github_tarball => "samjsharpe/puppet-ohmyzsh"
mod "dockutil", "0.1.2", :github_tarball => "grahamgilbert/puppet-dockutil"
mod "maximumawesome", "0.2.0", :github_tarball => "drewtempelmeyer/puppet-maximumawesome"
