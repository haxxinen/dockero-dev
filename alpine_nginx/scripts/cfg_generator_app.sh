#!/usr/bin/env bash
# Nginx app config generator.
# Warning: PROJECT_NAME, DOMAIN, SSL must be set as environmental variable(s).
# $ export PROJECT_NAME=webdev
# $ export DOMAIN=local
# $ export SSL=1
# $ bash cfg_generator_app.sh > nginx_app.conf

[[ \
   -z `env | grep -oE PROJECT_NAME=` || -z $PROJECT_NAME || \
   -z `env | grep -oE DOMAIN=` || -z $DOMAIN || \
   -z `env | grep -oE SSL=` || -z $SSL
]] && echo "[ERROR:$0] Missing environmental variable(s)." && exit

site=$PROJECT_NAME'.'$DOMAIN
ssl_key='/etc/nginx/ssl/'$site'.pem'

### config ###
default="
`[ $SSL -eq 1 ] && echo "
server {
    server_name                         $site www.$site;
    listen                              80 default;
    rewrite                             ^ https://\\$server_name\\$request_uri? permanent;
}
"`

server {
    server_name                         $site www.$site;
    root                                /var/www/$site/public;
    index                               index index.php index.html;
    listen `[ $SSL -eq 1 ] && echo '                             443 ssl' || echo '                             80 default'`;

    access_log                          /var/log/nginx/$site.access.log;
    error_log                           /var/log/nginx/$site.error.log;

    location / {
        try_files                       \$uri \$uri/ /index.php?\$query_string;
    }

    location ~* \.php\$ {
        include                         /etc/nginx/fastcgi_params;

        fastcgi_pass                    127.0.0.1:9000;
        fastcgi_index                   index.php;
        fastcgi_split_path_info         ^(.+\.php)(/.+)\$;
        fastcgi_param PATH_INFO         \$fastcgi_path_info;
        fastcgi_param PATH_TRANSLATED   \$document_root\$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME   \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors        on;
    }

    `[ $SSL -eq 1 ] && echo "### ssl"`
    `[ $SSL -eq 1 ] && echo "ssl_certificate                     $ssl_key;"`
    `[ $SSL -eq 1 ] && echo "ssl_certificate_key                 $ssl_key;"`

    ### security headers
    more_set_headers                    \"X-Frame-Options: DENY\";
    more_set_headers                    \"X-XSS-Protection: 1;mode=block\";
    `[ $SSL -eq 1 ] && echo "more_set_headers                    \\"Strict-Transport-Security 'max-age=31536000; includeSubdomains'\\";"`
}
"
echo "$default"
