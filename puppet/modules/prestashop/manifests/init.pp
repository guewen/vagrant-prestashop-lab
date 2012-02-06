class prestashop {
  
  exec { "create-prestashop-db":
        unless => "/usr/bin/mysql -uroot -p${lucid32_base::db_root_password} prestashop",
        command => "/usr/bin/mysql -uroot -p${lucid32_base::db_root_password} -e \"create database prestashop;\"",
        require => [Service["mysql"], Exec["set-mysql-password"]]
  }

  exec { "grant-prestashop-db-all":
        unless => "/usr/bin/mysql -u${lucid32_base::eshop_mysql_user} -p${lucid32_base::eshop_mysql_password} prestashop",
        command => "/usr/bin/mysql -uroot -p${lucid32_base::db_root_password} -e \"grant all on *.* to ${lucid32_base::eshop_mysql_user}@'%' identified by '${lucid32_base::eshop_mysql_password}' WITH GRANT OPTION;\"",
        require => [Service["mysql"], Exec["create-prestashop-db"]]
  }
      
  exec { "grant-prestashop-db-localhost":
        unless => "/usr/bin/mysql -u${lucid32_base::eshop_mysql_user} -p${lucid32_base::eshop_mysql_password} prestashop",
        command => "/usr/bin/mysql -uroot -p${lucid32_base::db_root_password} -e \"grant all on *.* to ${lucid32_base::eshop_mysql_user}@'localhost' identified by '${lucid32_base::eshop_mysql_password}' WITH GRANT OPTION;\"",
        require => Exec["grant-prestashop-db-all"]
  }

  exec { "download-prestashop":
    cwd => "/tmp",
    command => "/usr/bin/wget ${lucid32_base::eshop_archive_url}",
    creates => "/tmp/${lucid32_base::eshop_archive_name}"
  }
  
  exec { "untar-prestashop":
    cwd => "${lucid32_base::source_directory}",
    command => "/usr/bin/unzip /tmp/${lucid32_base::eshop_archive_name}",
    require => [Exec["download-prestashop"], Class["php"]]
  }

#  exec { "setting-permissions":
#    cwd => "${lucid32_base::root_document}",
#    command => "/bin/chmod 550 mage; /bin/chmod o+w var var/.htaccess app/etc; /bin/chmod -R o+w media",
#    require => Exec["untar-prestashop"],
#  }
  
#  exec { "install-prestashop":
#    cwd => "${lucid32_base::root_document}/",
#    creates => "${lucid32_base::root_document}/app/etc/local.xml",
#    command => '/usr/bin/php -f install.php -- \
#    --license_agreement_accepted "yes" \
#    --locale "en_US" \
#    --timezone "America/Los_Angeles" \
#    --default_currency "EUR" \
#    --db_host "localhost" \
#    --db_name "magentodb" \
#    --db_user "${lucid32_base::eshop_mysql_user}" \
#    --db_pass "${lucid32_base::eshop_mysql_password}" \
#    --url "${lucid32_base::site_url}" \
#    --use_rewrites "yes" \
#    --use_secure "no" \
#    --secure_base_url "${lucid32_base::site_url}" \
#    --use_secure_admin "no" \
#    --skip_url_validation "yes" \
#    --admin_firstname "Store" \
#    --admin_lastname "Owner" \
#    --admin_email "${lucid32_base::eshop_admin_email}" \
#    --admin_username "${lucid32_base::eshop_admin_login}" \
#    --admin_password "${lucid32_base::eshop_admin_password}"',
#    require => [Exec["setting-permissions"],Exec["create-magentodb-db"]],
#  }
  
}
