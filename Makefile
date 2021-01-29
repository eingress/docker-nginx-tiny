
include .env
export

SHELL := /bin/bash

.PHONY: build push release

build:
	docker build --squash \
		--build-arg ALPINE_VERSION=$$ALPINE_VERSION \
		--build-arg NGINX_VERSION=$$NGINX_VERSION \
		-t $$IMAGE_NAME:$$IMAGE_VERSION \
		-t $$IMAGE_NAME:latest \
		.

push:
	docker push --all-tags $$IMAGE_NAME

release: build push