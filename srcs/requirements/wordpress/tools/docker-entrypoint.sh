#!/bin/sh

set -e

umask 0002
if [ ! -e wp-config.php ]; then
	wp core download --path=/var/www --locale=ko_KR --version=6.3.1
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
		echo bonus profile found.
		if ! wp plugin get redis-cache 2&> /dev/null; then
			wp config set WP_REDIS_HOST "redis"
			wp config set WP_REDIS_PORT "6379"
			wp plugin install redis-cache --activate
			wp redis enable
		fi
#		if ! wp plugin get wp-mail-smtp 2&> /dev/null; then
#			wp config set WPMS_ON true
#			wp config set WPMS_SMTP_HOST exim
#			wp config set WPMS_SMTP_PORT 25
#			wp config set WPMS_SSL ""				# '', 'ssl', 'tls'
#			wp config set WPMS_SMTP_AUTH true
#			wp config set WPMS_SMTP_USER $EXIM_USER	# Auth username
#			wp config set WPMS_SMTP_PASS $EXIM_PASS	# Auth password
#			wp config set WPMS_SMTP_AUTOTLS true
#			wp config set WPMS_MAILER smtp
#			wp plugin install wp-mail-smtp --activate
#		fi
#		if ! wp plugin get comment-reply-email-notification 2&> /dev/null; then
#			wp plugin install comment-reply-email-notification --activate
#		fi
	fi
done

wp plugin update --all

# Execute
php-fpm81 -F
