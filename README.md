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
* PHPMyadmin
  * http://host.dev/phpmyadmin
* curl
* git
* vim

Virtual host domain and mysql root password are customizable in Vagrantfile:

```ruby
config.vm.provision "shell" do |s|
  s.path = "shell/script.sh"
  s.args = "host.dev mysql" # DOMAIN MYSQL_PASSWORD
end
```

### Remember
* `vagrant ssh` to enter in guest
* `vagrant suspend` to stop vagrant and save guest status
* `vagrant halt` to stop vagrant and shutdown guest
* `vagrant destroy` to stop vagrant and destroy all, if you wish start from scratch again
