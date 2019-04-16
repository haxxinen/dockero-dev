#### 1. Simple build
```
# docker build -t haxxinen/alpine_base .
# docker run --rm -it haxxinen/alpine_base sh
```


#### 2. Build and run with SSH/Supervisor support

##### 2.1. Via CLI
```
# docker build \
--build-arg "INSTALL_SSH=1" \
--build-arg "SSH_USER=noroot" \
--build-arg "SSH_PASS=noroot" \
-t haxxinen/alpine_base .

# docker run --rm -d -p 2222:22 \
-v `pwd`/configs/supervisord.conf:/etc/supervisord.conf \
haxxinen/alpine_base

# ssh noroot@localhost -p 2222
```

##### 2.3. Via compose
```
# docker-compose up --build -d
# ssh noroot@127.0.0.1 -p 2222
```


#### 3. Remove image
```
# docker rmi -f haxxinen/alpine_base
```


#### 4. Troubleshooting

In case of `WARNING: Ignoring http://...: temporary error (try again later)`:

```
# /etc/init.d/docker restart
```
