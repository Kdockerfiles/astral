**[Dockerized](https://hub.docker.com/r/kdockerfiles/astral/) [Astral](https://github.com/astralapp/astral)**

# Usage
1. [Get OAuth App API keys](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/).
2. `$ docker run -e GITHUB_CLIENT_ID=<ID> -e GITHUB_CLIENT_SECRET=<secret> -e GITHUB_CALLBACK_URL=<url> ghcr.io/kdockerfiles/astral:6f5b706-1`
## 3. Get webserver attached.
* Should look for FPM at port `9000`.
* Should look for statics at `/var/www/html/public/`.
* Example configuration for [Caddy 1.x](https://caddyserver.com/):
```
localhost:80 {
    root /var/www/html/public/
    fastcgi / astral:9000 php

    rewrite {
        to {path} {path}/ /index.php?{query}
    }
}
```
* Example configuration for [Caddy 2.x](https://caddyserver.com/v2):
```
http://localhost:80 {
    root * /var/www/html/public/
    php_fastcgi astral:9000
    file_server
}
```
* If webserver is outside Docker, should add port forwarding (e.g. `-p "9000:9000"`) and volume mount (e.g. `-v /my/statics/dir/:/var/www/html/public/`) to Docker command.

* Check `exmaples` directory for an example `docker-compose.yml`.

# Notes
* It is switched to use SQLite as DB backend.
* Dockerfile currently contains an ad-hoc patch that disables automatic stars cache invalidation.
