# builder

ARG ALPINE_VERSION

FROM alpine:$ALPINE_VERSION as builder

ARG NGINX_VERSION

RUN apk add --no-cache --update \
	build-base \
	wget \
	zlib-dev

RUN mkdir -p /build && \
	cd /build && \
	wget -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	tar -zxvf nginx-${NGINX_VERSION}.tar.gz

WORKDIR /build/nginx-${NGINX_VERSION}

RUN	./configure \
	--error-log-path=/dev/stderr \
	--http-log-path=/dev/stdout \
	--with-cc-opt="-O2" \
	--with-ld-opt="-s -static" \
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
	&& make -j $(grep processor /proc/cpuinfo | wc -l) \
	&& make install \
	&& strip /usr/local/nginx/sbin/nginx


RUN addgroup -S nginx && adduser -S -G nginx nginx
RUN chown -R nginx /usr/local/nginx/html

# release

FROM scratch

LABEL maintainer "Scott Mathieson <scott@eingress.io>"

COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /etc/passwd /etc/group /etc/

COPY nginx.conf /usr/local/nginx/conf/

STOPSIGNAL SIGQUIT

EXPOSE 80

ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]

CMD ["-g", "daemon off;"]