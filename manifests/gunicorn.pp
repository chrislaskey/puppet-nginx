define nginx::gunicorn (
	servername => $title,
	gunicorn_port => 9000,
	nginx_port => 80,
	ssl => 'false',
	remove_default_site => 'true',
){

	file { "/etc/nginx/sites-available/${servername}":
		ensure => "present",
		content => template("nginx/gunicorn.conf"),
		owner => "root",
		group => "root",
		mode => "0644",
	}

	file { "/etc/nginx/sites-enabled/${servername}": 
		ensure => "link",
		path => "/etc/nginx/sites-available/${servername}",
		target => "/etc/nginx/sites-enabled/${servername}",
	}

	exec { "nginx-reloader-${servername}":
		command => "service nginx reload",
		path => "/bin:/sbin:/usr/bin:/usr/sbin",
		user => "root",
		group => "root",
		logoutput => "on_failure",
		refreshonly => "true",
		subscribe => [
			File["/etc/nginx/sites-available/${servername}"],
			File["/etc/nginx/sites-enabled/${servername}"],
		],
	}

	if $remote_default_site == 'true' {
		exec { "remove-default-site-if-exists":
			command => "rm /etc/nginx/sites-enabled/default",
			onlyif => "test -f /etc/nginx/sites-enables/default",
		}
	}

}
