#### Сборка
```
docker build -t wumvi/php.fpm.dev -f Dockerfile .
```

#### Ports
unix socket
```
/var/run/php7-fpm.sock
```

TCP port
```
9000
```

xdebug port
```
9001
``` 