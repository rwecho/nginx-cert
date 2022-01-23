# NginxWithCert
NginxWithCert 是一个 nginx 的 docker 容器，在官方的 nginx 镜像下增加了 crontab 和 cerbot，用来初始化和刷新 let's enctypt 证书。

## 声明
这不是一个拉下来就能用的脚本，因为我在.gitignore隐藏了一些敏感信息。

## 安装
nginx的可以通过外部挂在的方式，把网站的配置存储在host主机上面。

1. 按照 nginx 的官方说明，需要在 /etc/nginx/conf.d 下面创建不用域名对应的 conf 文件，例如官方的举例 example.com.conf。
所以我们只需要把不同域名的信息放在./etc/nginx/conf.d（注意第一个句号，表示相对路径）下面，通过docker的磁盘（volume）挂在机制，使之生效。
如下所示：
    ``` nginx
    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        server_name example.com www.example.com;
    }
    ```
1. 使用 docker 运行
首先通过 Dockerfile 把 certbot 和 crontab 集成镜像, 例如命名 rwecho/nginx-autocert:latest。
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
3. 使用 docker-compose 运行
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

4. 环境变量说明
   * DOMAINS 对应 cetbot 的参数 -d/--domains, 以逗号分隔多个域名
   * EMAIL 对应cetbot 的参数 -m，用以验证 cerbot 的通知。
   * COUNTRY 对应 run.sh 的自签名证书的俩位字母国家代码

## 参考:
[autocert](https://github.com/mattsbanner/autocert)
[Using let's cencrypt ssl/tls with nginx](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/)