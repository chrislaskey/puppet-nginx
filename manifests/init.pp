class nginx (
	$user = "www-data",
	$worker_processes = 4,
	$worker_connections = 768,
	$additional_fastcgi_params = "",
	$additional_uwsgi_params = "",
){

	# Packages
	# ==========================================================================

	package { "nginx":
		ensure => "installed",
	}

	# Service
	# ==========================================================================

	service { "nginx":
		name => "nginx",
		ensure => "running",
		enable => "true",
		pattern => "nginx",
		require => [
			Package["nginx"],
			File["nginx.conf"],
		],
	}

	# Files
	# ==========================================================================
	# Note: the "files" dir is ommitted when using puppet:///.

	if ! defined( File["/data/websites"] ) {
		file { "/data/websites":
			ensure => "directory",
			owner => "www-data",
			group => "www-data",
			mode => "0775",
		}
	}

	file { "nginx.conf":
		ensure => "present",
		path => "/etc/nginx/nginx.conf",
		content => template("nginx/nginx.conf"),
		owner => "root",
		group => "root",
		mode => "0644",
		require => [
			Package["nginx"],
		],
	}

	file { "fastcgi_params":
		ensure => "present",
		path => "/etc/nginx/fastcgi_params",
		content => template("nginx/fastcgi_params"),
		owner => "root",
		group => "root",
		mode => "0644",
		require => [
			File["nginx.conf"],
		],
	}

	file { "uwsgi_params":
		ensure => "present",
		path => "/etc/nginx/uwsgi_params",
		content => template("nginx/uwsgi_params"),
		owner => "root",
		group => "root",
		mode => "0644",
		require => [
			File["nginx.conf"],
		],
	}

	# Execs
	# ==========================================================================

	exec { "nginx-config-reloader":
		command => "service nginx reload",
		path => "/bin:/sbin:/usr/bin:/usr/sbin",
		user => "root",
		group => "root",
		logoutput => "on_failure",
		refreshonly => "true",
		subscribe => [
			File["fastcgi_params"],
			File["uwsgi_params"],
			File["nginx.conf"],
		],
	}

}
