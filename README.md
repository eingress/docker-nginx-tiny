# Nginx Tiny

A minimalist Nginx build for serving static assets over HTTP only; intended for use behind a TLS terminating load balancer.

Run using the bundled lightweight nginx.conf…

```shell
docker run -d -p 8080:80 -v /path/to/html:/usr/local/nginx/html eingressio/nginx-tiny
```

…or using a custom nginx.conf

```sh
docker run -d -p 8080:80 -v /path/to/html:/usr/local/nginx/html -v /path/to/nginx.conf:/usr/local/nginx/conf/nginx.conf eingressio/nginx-tiny
```
