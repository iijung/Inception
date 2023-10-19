#!/bin/sh

set -e

if [ ! -e wp-config.php ]; then
	wp config create \
		--force \
		--skip-check \
		--dbhost=mariadb \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbname=$MYSQL_DATABASE
fi

if ! wp core is-installed; then
	wp core install \
		--locale=ko_KR \
		--url=${DOMAIN_NAME} \
		--title=Inception \
		--admin_user=${WORDPRESS_ADMIN_USER} \
		--admin_email=${WORDPRESS_ADMIN_EMAIL} \
		--admin_password=${WORDPRESS_ADMIN_PASSWORD}
	wp user create \
		${WORDPRESS_USER} \
		${WORDPRESS_EMAIL} \
		--user_pass=${WORDPRESS_PASSWORD}
fi

for profile in ${COMPOSE_PROFILES//,/$IFS}; do
	if [ "$profile" == "bonus" ]; then
		if wp plugin get redis-cache; then
			wp config set WP_REDIS_HOST "reids"
			wp config set WP_REDIS_PORT "6379"
			wp redis enable
		fi
	fi
done

wp plugin update --all

# Execute
php-fpm81 -F
