class php
{

  package
  {
    'apache2':
      ensure => present,
      require => Package['mysql-server']
  }

  package
  {
    'php5':
      ensure => present,
      require => Package['apache2']
  }
  
  package
  {
    'php5-dev':
      ensure => present,
      require => Package['php5']
  }  

  package
  {
    'php5-intl':
      ensure => present,
      require => Package['php5']
  }

  package
  {
    'php5-curl':
      ensure => present,
      require => Package['php5']
  }

  package
  {
    'php5-mcrypt':
      ensure => present,
      require => Package['php5']
  }
  
  package
  {
    'php5-gd':
      ensure => present,
      require => Package['php5']
  }

#  package
#  {
#    'php5-pdo':
#      ensure => present,
#      require => Package['php5']
#  }
  
#  package
#  {
#    'php5-pecl':
#      ensure => present,
#      require => Package['php5']
#  }

  package
  {
    'phpmyadmin':
      ensure => present,
      require => Package['php5']
  }

  package
  {
    'php5-cli':
      ensure => present,
      require => Package['php5']
  }

  package
  {
    'php-pear':
      ensure => present,
      require => Package['php5-cli']
  }
  
}
