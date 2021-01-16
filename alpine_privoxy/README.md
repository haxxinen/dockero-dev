#### Build
```
# docker build -t privoxy .
```

#### Run
```
# docker run --rm -d \
-v `pwd`/configs/supervisord.conf:/etc/supervisord.conf \
--name privoxy \
-p 8118:8118 privoxy
```

### Run with modified privoxy config

```
# cat << EOF > configs/newconf.conf
listen-address  0.0.0.0:8118
forward   /   myupstreamproxy.com:8080
EOF
```

```
# docker run --rm -d \
-v `pwd`/configs/newconf.conf:/etc/privoxy/config \
-v `pwd`/configs/supervisord.conf:/etc/supervisord.conf \
--name privoxy \
-p 8118:8118 privoxy
```
