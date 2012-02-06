class magento {
  
  exec { "create-magentodb-db":
        unless => "/usr/bin/mysql -uroot -p${lucid32_base::db_root_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${lucid32_base::db_root_password} -e \"create database magentodb;\"",
        require => [Service["mysql"], Exec["set-mysql-password"]]
  }

  exec { "grant-magentodb-db-all":
        unless => "/usr/bin/mysql -umagento -p${db_magento_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${lucid32_base::db_root_password} -e \"grant all on *.* to ${lucid32_base::eshop_mysql_user}@'%' identified by '${lucid32_base::eshop_mysql_password}' WITH GRANT OPTION;\"",
        require => [Service["mysql"], Exec["create-magentodb-db"]]
  }
      
  exec { "grant-magentodb-db-localhost":
        unless => "/usr/bin/mysql -umagento -p${lucid32_base::db_magento_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${lucid32_base::db_root_password} -e \"grant all on *.* to ${lucid32_base::eshop_mysql_user}@'localhost' identified by '${lucid32_base::eshop_mysql_password}' WITH GRANT OPTION;\"",
        require => Exec["grant-magentodb-db-all"]
  }

  exec { "download-magento":
    cwd => "/tmp",
    command => "/usr/bin/wget http://www.magentocommerce.com/downloads/assets/1.6.0.0/magento-1.6.0.0.tar.gz",
    creates => "/tmp/magento-1.6.0.0.tar.gz"
  }
  
  exec { "untar-magento":
    cwd => "${lucid32_base::source_directory}",
    command => "/bin/tar xvzf /tmp/magento-1.6.0.0.tar.gz",
    require => [Exec["download-magento"], Class["php"]]
  }

  exec { "setting-permissions":
    cwd => "${lucid32_base::root_document}",
    command => "/bin/chmod 550 mage; /bin/chmod o+w var var/.htaccess app/etc; /bin/chmod -R o+w media",
    require => Exec["untar-magento"],
  }
  
  exec { "install-magento":
    cwd => "${lucid32_base::root_document}/",
    creates => "${lucid32_base::root_document}/app/etc/local.xml",
    command => '/usr/bin/php -f install.php -- \
    --license_agreement_accepted "yes" \
    --locale "en_US" \
    --timezone "America/Los_Angeles" \
    --default_currency "EUR" \
    --db_host "localhost" \
    --db_name "magentodb" \
    --db_user "${lucid32_base::eshop_mysql_user}" \
    --db_pass "${lucid32_base::eshop_mysql_password}" \
    --url "${lucid32_base::site_url}" \
    --use_rewrites "yes" \
    --use_secure "no" \
    --secure_base_url "${lucid32_base::site_url}" \
    --use_secure_admin "no" \
    --skip_url_validation "yes" \
    --admin_firstname "Store" \
    --admin_lastname "Owner" \
    --admin_email "${lucid32_base::eshop_admin_email}" \
    --admin_username "${lucid32_base::eshop_admin_login}" \
    --admin_password "${lucid32_base::eshop_admin_password}"',
    require => [Exec["setting-permissions"],Exec["create-magentodb-db"]],
  }
  
}
