#!/usr/bin/env sh
# Install Nginx from source.
# Warning: following must be set as env variables.
#          - NGINX_VERSION={latest|...}

[ ! `id -u` -eq 0 ] && echo 'Not root.' && exit

[[ \
   -z "`env | grep -oE NGINX_VERSION=`" || -z "$NGINX_VERSION" || \
   -z "`which make`" || -z "`which g++`" || -z "`which wget`" || -z "`which curl`" \
]] && echo "[ERROR:$0] Missing environmental variable(s)." && exit


# nginx source download
site_url='http://nginx.org'
if [ "$NGINX_VERSION" == 'latest' ]
then
   NGINX_VERSION=`curl -sSL $site_url | grep -oE 'nginx-([0-9]{1,}\.){1,}[0-9]{1,}' |  head -n 1`
else
   NGINX_VERSION='nginx-'$NGINX_VERSION
   code=`curl -sSL -w "%{http_code}" \
         $site_url'/download/'$NGINX_VERSION'.tar.gz' \
         -o /dev/null`
   [ ! $code -eq 200 ] && exit
fi

# script variables
nginx_path='/etc/nginx'
log_access='/var/log/nginx/access.log'
log_error='/var/log/nginx/error.log'
workdir="/tmp/$RANDOM$RANDOM"; mkdir $workdir; cd $workdir

# module(s) from Github
set -- \
'openresty/headers-more-nginx-module' # ...

configure_mods=''
while [ $# -gt 0 ]
do
   mod_name=`echo $1 | awk -F '/' {'print $NF'}`
   mod_arch=$mod_name'.tar.gz'

   mod=`curl -sSL "https://github.com/$1/tags" | grep -oE "/$1/archive/refs/tags/v.*tar.gz" | head -n 1`
   [ -z $mod ] && shift && continue

   wget -q 'https://github.com'$mod -O $mod_arch && tar xfz $mod_arch && rm $mod_arch
   configure_mods=$configure_mods'--add-module='$(echo `pwd`/$mod_name*)" "
   shift
done

wget -q $site_url'/download/'$NGINX_VERSION'.tar.gz'
tar xzf $NGINX_VERSION'.tar.gz' && cd $NGINX_VERSION
./configure \
   --prefix=$nginx_path \
   --with-http_ssl_module \
   --with-http_gzip_static_module \
   --http-log-path=$log_access \
   --error-log-path=$log_error \
   --sbin-path='/usr/sbin/nginx' \
   "$configure_mods"

make && make install
rm -r $workdir
