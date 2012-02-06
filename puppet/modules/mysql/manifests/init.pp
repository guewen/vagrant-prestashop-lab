class mysql {

  package { "mysql-server": ensure => installed;
            "mysql-client": ensure => installed;
            "libmysqlclient15-dev": ensure => installed;
          }
    
  service { "mysql":
               enable => true,
               ensure => running,
               require => Package["mysql-server"],
  }
            
  exec { "set-mysql-password":
     unless => "mysqladmin -uroot -p${lucid32_base::db_root_password} status",
     path => ["/bin", "/usr/bin"],
     command => "mysqladmin -uroot password ${lucid32_base::db_root_password}",
     require => Service["mysql"],
  }
  
}
