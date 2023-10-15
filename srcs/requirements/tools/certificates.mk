# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    certificates.mk                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: minjungk <minjungk@student.42seoul.>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/15 08:57:25 by minjungk          #+#    #+#              #
#    Updated: 2023/10/15 11:08:43 by minjungk         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

include .env

.DELETE_ON_ERROR:
.DEFAULT_GOAL	:= all

# **************************************************************************** #
# global rules
# **************************************************************************** #
.PHONY: all clean fclean re

all: $(CERTS_)/$(DOMAIN_NAME).pem

clean fclean:
	$(RM) $(wildcard $(CERTS_)/*.key)
	$(RM) $(wildcard $(CERTS_)/*.crt)
	$(RM) $(wildcard $(CERTS_)/*.csr)
	$(RM) $(wildcard $(CERTS_)/*.pem)

re: fclean
	$(MAKE)

# **************************************************************************** #
# for openssl
# **************************************************************************** #
.PRECIOUS: %.key %.csr %.crt

%.pem: %.crt $(CERTS_)/root-ca.crt
	cat $^ > $@

%.csr: %.key
	openssl req \
		-new \
		-key $< \
		-subj "/C=KR/ST=Seoul/L=Gangnamgu/O=42Seoul/CN=$(basename $(@F))" \
		-out $@

%.crt: %.csr $(CERTS_)/root-ca.crt
	openssl x509 \
		-req \
		-sha256 \
		-days 30 \
		-CAkey $(CERTS_)/root-ca.key \
		-CA $(CERTS_)/root-ca.crt \
		-subj "/C=KR/ST=Seoul/L=Gangnamgu/O=42Seoul/CN=$(basename $(@F))" \
		-in $< \
		-out $@
	openssl x509 -in $@ -text

%/root-ca.crt: %/root-ca.key
	openssl req \
		-x509 \
		-new \
		-nodes \
		-sha256 \
		-key $< \
		-days 365 \
		-subj "/C=KR/ST=Seoul/L=Gangnamgu/O=42Seoul/CN=root-ca" \
		-out $@
	openssl x509 -in $@ -text

%.key:
	openssl genrsa -out $@ 2048
