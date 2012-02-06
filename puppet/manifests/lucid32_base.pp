class lucid32_base {
  
  $host = "prestashop.dev"
  $db_root_password = "root"

  $source_directory = "/vagrant/project"
  $site_url = "http://${host}/"

  $eshop_admin_login = "admin"
  $eshop_admin_password = "GB123456z"
  $eshop_admin_email = "email@email.com"

  $eshop_mysql_user = 'prestashop'
  $eshop_mysql_password = 'prestashop'

  $eshop_archive_url = 'http://www.prestashop.com/download/prestashop_1.5.0.3.zip'
  $eshop_archive_name = 'prestashop_1.5.0.3.zip'

  # setup the document root
  $root_document = "${source_directory}/prestashop"

  package { "wget": ensure => "present", }
  package { "unzip": ensure => "present", }

  # puppet complains about a missing puppet group so create it
  group { 'puppet': ensure => 'present' }

  # packages are not update to date out of the box
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

  # setup hosts for $host and www.$host having www.$host and $host map to the same site
  host { "$host":
    ensure => "present",
    ip => "127.0.0.1",
    host_aliases => [ "www.$host"],
  }

  include mysql
  include php
  include svn
  include config
  include prestashop


}

include lucid32_base
