#!/usr/bin/env bash
# Provision WordPress demo

# Make a database, if we don't already have one
echo -e "\nCreating database 'wordpress_deafault' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS demo"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON demo.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

# Install and configure the latest demo version of WordPress
if [[ ! -d "${VVV_PATH_TO_SITE}/public_html" ]]; then

  echo "Downloading WordPress Demo, see http://wordpress.org/"
  cd ${VVV_PATH_TO_SITE}
  curl -L -O "https://wordpress.org/latest.tar.gz"
  noroot tar -xvf latest.tar.gz
  mv wordpress public_html
  rm latest.tar.gz
  cd ${VVV_PATH_TO_SITE}/public_html

  echo "Configuring WordPress demo..."
  noroot wp core config --dbname=demo --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP

  echo "Installing WordPress demo..."
  noroot wp core install --url=demo.dev --quiet --title="Demo" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password"

else

  echo "Updating WordPress demo..."
  cd ${VVV_PATH_TO_SITE}/public_html
  noroot wp core update

fi
