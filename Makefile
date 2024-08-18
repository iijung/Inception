# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: minjungk <minjungk@student.42seoul.kr>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/07 05:17:52 by minjungk          #+#    #+#              #
#    Updated: 2024/08/18 09:14:33 by minjungk         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

.DELETE_ON_ERROR:
.DEFAULT_GOAL	:= all

# **************************************************************************** #
# pre-defined environment in docker-compose
# **************************************************************************** #
export COMPOSE_PROJECT_NAME				:= inception
export COMPOSE_FILE						:= srcs/docker-compose.yml
#export COMPOSE_PROFILES					:= 
#export COMPOSE_CONVERT_WINDOWS_PATHS	:= 
#export COMPOSE_PARALLEL_LIMIT			:=
#export COMPOSE_IGNORE_ORPHANS			:= no
#export COMPOSE_REMOVE_ORPHANS			:=
#export COMPOSE_PATH_SEPARATOR			:=
#export COMPOSE_STATUS_STDOUT			:=
#export COMPOSE_ANSI						:=
#export DOCKER_CERT_PATH					:= 

# **************************************************************************** #
# global rules
# **************************************************************************** #
.PHONY: all clean fclean re bonus

DOCKER	:= docker
COMPOSE	:= $(DOCKER) compose

VOLUME_PATH			:= $(HOME)/data
MARIADB_VOLUME		:= $(VOLUME_PATH)/mariadb
WORDPRESS_VOLUME	:= $(VOLUME_PATH)/wordpress
export MARIADB_VOLUME WORDPRESS_VOLUME

all: setup ssl
	@mkdir -p $(MARIADB_VOLUME) $(WORDPRESS_VOLUME)
	$(COMPOSE) up -d --build

clean:
	export COMPOSE_PROFILES=bonus; \
	$(COMPOSE) down --rmi all --volumes

fclean: clean
	docker system prune -f --all
	@sudo rm -rf $(VOLUME_PATH)

re: fclean
	$(MAKE) all

bonus:
	export COMPOSE_PROFILES=bonus; \
	$(MAKE) all

show: ps images network volume

# **************************************************************************** #
# make environment
# **************************************************************************** #
.PHONY: setup

ENVIRON_FILE	:= srcs/.env
TEMPLATE_FILE	:= srcs/.env.template

setup: | $(ENVIRON_FILE)
$(ENVIRON_FILE): $(TEMPLATE_FILE)
	@echo "Creating $@ file..."
	@echo -n > $@
	@while IFS= read -r line <&3; do \
		if echo "$$line" | grep -qE '[^#].*=.*'; then \
			read -p "$$line" value; \
			echo "$$line$$value" >> $@; \
		else \
			echo "$$line" >> $@; \
		fi \
	done 3< "$(TEMPLATE_FILE)"
	@echo "$@ file created successfully."

# **************************************************************************** #
# openssl
# **************************************************************************** #
.PHONY: ssl ssl-clean

ssl: #| ${CERTS_}/${DOMAIN_NAME}.crt
	make -C srcs -f ./requirements/tools/certificates.mk

ssl-clean:
	make -C srcs -f ./requirements/tools/certificates.mk clean

# **************************************************************************** #
# for monitoring
# **************************************************************************** #
.PHONY: version ps top logs events

version ps top logs events:
	export COMPOSE_PROFILES=bonus; \
	$(COMPOSE) $@

.PHONY: network volume

network volume:
	$(DOCKER) $@ ls

.PHONY: config build images pull push

config build images pull push:
	$(COMPOSE) $@

# **************************************************************************** #
# for container
# **************************************************************************** #
.PHONY: scale create rm

scale:
	$(COMPOSE) scale $(service-name)=$(number)

create rm:
	$(COMPOSE) $@

# **************************************************************************** #
# for service
# **************************************************************************** #
.PHONY: run exec port kill

run:
	$(COMPOSE) run $(servic-name) $(command)

exec:
	$(COMPOSE) exec $(servic-name) $(command)

port:
	$(COMPOSE) port $(servic-name) $(port)

kill:
	$(COMPOSE) kill

.PHONY: start restart stop pause unpause

start restart stop pause unpause:
	$(COMPOSE) $@ $(OPTS)
