vagrant-shell-lamp
==================

Using shell provision for vagrant box with LAMP

## Usage
1. Clone this repository
2. Inside directory where is Vagrantfile, run `vagrant up`

  log is saved in `./shell/log.txt`

3. Add `192.168.33.10  host.dev` to `/etc/hosts` of host

### This provides a simple LAMP with some extra tools:
* Apache2 webserver
  * virtual host http://host.dev
  * mod_rewrite with .htaccess support
  * web directory `/vagrant/www` in guest is shared as ./www in host
* PHP5
* MySQL5 (root password: `mysql`)
* Exim4 for email sending
* PHPMyadmin
  * http://host.dev/phpmyadmin
* curl
* git
* vim

Virtual host domain and mysql root password are customizable in `Vagrantfile`:

```ruby
PRIVATE_NETWORK_IP = "192.168.33.10"
HOSTNAME = "precise32"
VIRTUALHOST_DOMAIN = "precise32.dev"
MYSQL_ROOT_PASSWORD = "mysql"
```

### Remember
* `vagrant ssh` to enter in guest
* `vagrant suspend` to stop vagrant and save guest status
* `vagrant halt` to stop vagrant and shutdown guest
* `vagrant destroy` to stop vagrant and destroy all, if you wish start from scratch again
