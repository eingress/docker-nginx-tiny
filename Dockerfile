FROM alpine

LABEL maintainer "Scott Mathieson <scott@eingress.io>"

ARG NGINX_VERSION=1.17.3

RUN apk add -t build-deps --no-cache --update \
	build-base wget zlib-dev && \
	mkdir -p /build && \
	cd /build && \
	wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	tar -zxvf nginx-${NGINX_VERSION}.tar.gz && \
	cd /build/nginx-${NGINX_VERSION} && \
	./configure \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--with-cc-opt="-O2" \
	--with-ld-opt="-s" \
	--without-http_access_module \
	--without-http_auth_basic_module \
	--without-http_autoindex_module \
	--without-http_browser_module \
	--without-http_empty_gif_module \
	--without-http_fastcgi_module \
	--without-http_geo_module \
	--without-http_grpc_module \
	--without-http_limit_conn_module \
	--without-http_limit_req_module \
	--without-http_map_module \
	--without-http_memcached_module \
	--without-http_mirror_module \
	--without-http_proxy_module \
	--without-http_rewrite_module \
	--without-http_scgi_module \
	--without-http_split_clients_module \
	--without-http_upstream_hash_module \
	--without-http_upstream_ip_hash_module \
	--without-http_upstream_keepalive_module \
	--without-http_upstream_least_conn_module \
	--without-http_upstream_zone_module \
	--without-http_userid_module \
	--without-http_uwsgi_module \
	&& make && make install && \
	rm -rf /build && \
	apk del build-deps


RUN addgroup -S nginx && adduser -S -G nginx nginx
RUN chown -R nginx /usr/local/nginx/html
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

ENV PATH="/usr/local/nginx/sbin:${PATH}"

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]