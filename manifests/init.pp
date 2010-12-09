# Class: serverdensity
#
# This class installs and configures the Server Density monitoring agent: http://www.serverdensity.com/
#
# Notes:
#  This class is Ubuntu/Debian specific for now.
#  By Sean Porter <portertech@gmail.com>
#
# Actions:
#  - Adds to the apt repository list
#  - Installs and configures the Server Density monitoring agent, sd-agent
#
# Sample Usage (Monitoring MongoDB):
#  include serverdensity
#
#  serverdensity::config { "server-density-subdomain":
#    agent_key => "b82e833n4o9h189a352k8ds67725g3jy",
#    options => ["mongodb_server: localhost"],
#  }
#
class serverdensity {
	define config ( $agent_key, $options=[""] ) {
		exec { "server-density-apt-key":
			path => "/bin:/usr/bin",
			command => "wget http://www.serverdensity.com/downloads/boxedice-public.key -O - | apt-key add -",
			unless => "apt-key list | grep -i boxedice",
		}

		exec { "server-density-apt-list":
			path => "/bin:/usr/bin",
			command => "echo 'deb http://www.serverdensity.com/downloads/linux/debian lenny main' >> /etc/apt/sources.list;apt-get update",
			unless => "cat /etc/apt/sources.list | grep -i serverdensity",
			require => Exec["server-density-apt-key"],
		}

		package { "sd-agent":
			ensure => installed,
			require => Exec["server-density-apt-list"],
		}

		file { "/etc/sd-agent/config.cfg":
			content => template("serverdensity/config.cfg.erb"),
			mode => "0644",
			require => Package["sd-agent"],
		}
		
		service { "sd-agent":
			ensure => running,
			enable => true,
			subscribe => Package["sd-agent"],
			require => File["/etc/sd-agent/config.cfg"],
		}
	}
}
