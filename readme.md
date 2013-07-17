About
================================================================================

An puppet module for installing Nginx on Ubuntu 12.04 / Debian 7.

nginx::gunicorn
---------------

Define a specific nginx configuration for a gunicorn site. Optimized for Django
but can be used for Flask as well.

Here is an example with all optional parameters and their default values:

```puppet
nginx::gunicorn { "servername.com":
	servername => $title,
	gunicorn_port => 9000,
	nginx_port => 80,
	ssl => 'false',
	remove_default_site => 'true',
}
```

License
================================================================================

All code written by me is released under MIT license. See the attached
license.txt file for more information, including commentary on license choice.
