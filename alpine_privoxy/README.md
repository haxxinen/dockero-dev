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
