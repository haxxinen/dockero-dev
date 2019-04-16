#!/usr/bin/env sh
# Nginx server config generator.
# Warning: SSL must be set as environmental variable(s).
# $ export SSL=1
# $ bash cfg_generator_srv.sh > nginx_srv.conf

[[ \
   -z `env | grep -oE SSL=` || -z $SSL \
]] && echo "[ERROR:$0] Missing environmental variable(s)." && exit


conf="
user                                    www-data;
worker_processes                        auto;
events {
    worker_connections                  1024;
}
http {
    server_tokens                        off;
    include                              mime.types;
    default_type                         application/octet-stream;
    sendfile                             on;
    keepalive_timeout                    65;
    client_max_body_size                 24000M;
    index                                index.html index.php;
    include                              /etc/nginx/sites-enabled/*;

    ## LOGGING
    log_format  main                     '\$remote_addr - \$remote_user [\$time_local] "\$request"'
                                         '\$status \$body_bytes_sent "\$http_referer" '
                                         '"\$http_user_agent" "\$http_x_forwarded_for"';
    access_log                           /var/log/nginx/access.log;
    error_log                            /var/log/nginx/error.log;

    
    ## SSL SUPPORT
    `[ $SSL -eq 1 ] && echo "ssl_prefer_server_ciphers            on;"`
    `[ $SSL -eq 1 ] && echo "ssl_session_timeout                  10m;"`
    `[ $SSL -eq 1 ] && echo "ssl_session_cache                    shared:SSL:10m;"`
    `[ $SSL -eq 1 ] && echo "ssl_protocols                        TLSv1.2 TLSv1.3;"`

    ## CLEAR RESPONSE HEADERS
    more_clear_headers                   'Server:';
    more_clear_headers                   'X-Powered-By:';
    more_clear_headers                   'Accept-Ranges:';
    more_clear_headers                   'Content-Length:';
    more_clear_headers                   'Date:';
    more_clear_headers                   'ETag:';
    more_clear_headers                   'Last-Modified:';
    more_clear_headers                   'Transfer-Encoding:';
}
"

echo "$conf"
