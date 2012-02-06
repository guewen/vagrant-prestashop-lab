class config
{

  file
  {
    'apache2.config':
      path => '/etc/apache2/sites-available/default',
      ensure => present,
      source => '/vagrant/resources/app/etc/apache2/sites-available/default',
      notify => Service[apache2]
  }

  exec
  {
    'apache2.mods':
      path => '/bin:/usr/bin:/usr/sbin',
      command => 'a2enmod rewrite',
      require => File['apache2.config'],
      notify => Service[apache2]
  }

  file
  {
    'php5.config':
      path => '/etc/php5/apache2/php.ini',
      ensure => present,
      source => '/vagrant/resources/app/etc/php5/apache2/php.ini',
      notify => Service[apache2]
  }

  file
  {
    'php5cli.config':
      path => '/etc/php5/cli/php.ini',
      ensure => '/etc/php5/apache2/php.ini',
      require => File['php5.config']
  }

  # the mcrypt.ini file creates a notice when starting the php.cli,
  # removing the comment in the file fixes it
  file
  {
    'mcrypt.fix':
      path => '/etc/php5/conf.d/mcrypt.ini',
      ensure => '/vagrant/resources/app/etc/php5/conf.d/mcrypt.ini',
      require => File['php5.config'],
  }

  file
  {
    'phpmyadmin.apacheconfig':
      path => '/etc/apache2/conf.d/apache.conf',
      ensure => '/etc/phpmyadmin/apache.conf',
      require => File['php5.config'],
      notify => Service[apache2]
  }

  file
  {
    'project.basedir':
      path => '/vagrant/project',
      ensure => directory
  }

  file
  {
    'system.logdir':
      path => '/vagrant/log',
      ensure => directory
  }

  file
  {
    'apache.logdir':
      path => '/vagrant/log/apache2',
      ensure => directory,
      require => File['system.logdir']
  }

  service { apache2:
    ensure => running,
  }

}
