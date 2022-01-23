# NginxWithCert
NginxWithCert is a nginx docker container with automatic certbot ssl certificates. It bases on official nginx image with crontab and cerbot.

## [中文](./readme.zh.md)
## Declaretion
This is not a pull-run script. Because some sensitive information is ignored by .gitignore.

## Installation
Nginx is a extensible host framework. With conf.d folder we can serve multiple domain-sites.

1. According official document of nginx sit. We mount ./etc/nginx/conf.d to /etc/nginx/confid in container.
    ``` nginx
    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        server_name example.com www.example.com;
    }
    ```

1. Run in dock
   Firstly build docker with Dockerfile with a name. For example: rwecho/nginx-autocert:latest
    ``` docker
    docker run \
        --name nginx-cert\
        -d \
        -e DOMAINS="example.com,www.example.com" \
        -e EMAIL="example@example.com" \
        -e COUNTRY="GB \
        -v ./etc/nginx/conf.d:/etc/nginx/conf.d \
        -v ./etc/letsencrypt:/etc/letsencrypt \
        -p 80:80 \
        -p 443:443 \
        rwecho/nginx-autocert:latest
    ```
2. Run in docker-compose
    ``` docker-copose
        version: '2.0'
        services:
        nginx:
            image: 'rwecho/nginx-autocert:latest'
            container_name: 'nginx-autocert'
            ports:
            - '80:80'
            - '443:443'
            volumes:
            - ./etc/nginx/conf.d:/etc/nginx/conf.d
            - ./etc/letsencrypt:/etc/letsencrypt
            restart: always
            environment:
            - EMAIL=example@example.com
            - DOMAINS=example.com,www.example.ecm
            - COUNTRY=GB
        ```

1. Environments
   * DOMAINS pass to cetbot s -d/--domains, comma-separated list of the domains
   * EMAIL pass to cetbot -m for Certbot notifications.
   * COUNTRY with your two letter country code

## References:
[autocert](https://github.com/mattsbanner/autocert)
[Using let's cencrypt ssl/tls with nginx](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/)