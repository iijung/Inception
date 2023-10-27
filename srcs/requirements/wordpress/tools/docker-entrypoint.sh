#!/bin/sh

set -e

sudo_wp() {
	su www -c "wp $*"
}

umask 0002
if [ ! -e wp-config.php ]; then
	sudo_wp core download --path=/var/www --locale=ko_KR --version=6.3.1
	sudo_wp config create \
		--force \
		--skip-check \
		--dbhost=mariadb \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_PASSWORD \
		--dbname=$MYSQL_DATABASE
fi

if ! sudo_wp core is-installed; then
	sudo_wp core install \
		--locale=ko_KR \
		--url=${DOMAIN_NAME} \
		--title=Inception \
		--admin_user=${WORDPRESS_ADMIN_USER} \
		--admin_email=${WORDPRESS_ADMIN_EMAIL} \
		--admin_password=${WORDPRESS_ADMIN_PASSWORD}
	sudo_wp user create \
		${WORDPRESS_USER} \
		${WORDPRESS_EMAIL} \
		--user_pass=${WORDPRESS_PASSWORD}
fi

for profile in ${COMPOSE_PROFILES//,/$IFS}; do
	if [ "$profile" == "bonus" ]; then
		echo bonus profile found.
		if ! sudo_wp plugin get redis-cache 2&> /dev/null; then
			sudo_wp config set WP_REDIS_HOST redis
			sudo_wp config set WP_REDIS_PORT 6379
			sudo_wp plugin install redis-cache --activate
			sudo_wp redis enable
		fi
		if ! sudo_wp plugin get wp-mail-smtp 2&> /dev/null; then
			sudo_wp config set WPMS_ON true --raw
			sudo_wp config set WPMS_SMTP_HOST exim
			sudo_wp config set WPMS_SMTP_PORT 25
			sudo_wp config set WPMS_SSL "''"				# '', 'ssl', 'tls'
			sudo_wp config set WPMS_SMTP_AUTH false --raw
			sudo_wp config set WPMS_SMTP_USER $EXIM_USER	# Auth username
			sudo_wp config set WPMS_SMTP_PASS $EXIM_PASS	# Auth password
			sudo_wp config set WPMS_SMTP_AUTOTLS false --raw
			sudo_wp config set WPMS_MAILER smtp
			sudo_wp plugin install wp-mail-smtp --activate
		fi
		if ! sudo_wp plugin get comment-reply-email-notification 2&> /dev/null; then
			sudo_wp plugin install comment-reply-email-notification --activate
		fi
	fi
done

sudo_wp plugin update --all

# Execute
php-fpm81 -F
