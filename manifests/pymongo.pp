# Class: serverdensity::pymongo
#
# This class installs PyMongo, the Python driver for MongoDB required by Server Density to monitor MongoDB
#
# Notes:
#  This class is Ubuntu/Debian specific for now.
#  By Sean Porter <portertech@gmail.com>
#
# Actions:
#  - Installs the Python setup tools
#  - Installs the Python MongoDB driver
#
# Sample Usage:
#  include serverdensity::pymongo
#  include serverdensity
#
class serverdensity::pymongo {
	package { "python-setuptools":
		ensure => installed,
	}
	
	exec { "install-pymongo":
		path => "/bin:/usr/bin",
		command => "easy_install pymongo",
		unless => "python -c 'import pymongo'",
		require => Package["python-setuptools"],
	}
}
