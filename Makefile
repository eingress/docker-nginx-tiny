include .env
export

SHELL := /bin/bash

.PHONY: build release

build:
	docker buildx build \
		--build-arg ALPINE_VERSION=$$ALPINE_VERSION \
		--build-arg NGINX_VERSION=$$NGINX_VERSION \
		--load \
		-t $$IMAGE_NAME:$$IMAGE_VERSION \
		-t $$IMAGE_NAME:latest \
		.

release:
	docker buildx build \
		--build-arg ALPINE_VERSION=$$ALPINE_VERSION \
		--build-arg NGINX_VERSION=$$NGINX_VERSION \
		--platform linux/amd64,linux/arm64 \
		--push \
		-t $$IMAGE_NAME:$$IMAGE_VERSION \
		-t $$IMAGE_NAME:latest \
		.
