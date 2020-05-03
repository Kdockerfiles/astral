**[Dockerized Astral](https://hub.docker.com/r/kdockerfiles/astral/)**

# Usage
1. [Get OAuth App API keys](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/).
2. `$ docker run -e GITHUB_CLIENT_ID=<ID> -e GITHUB_CLIENT_SECRET=<secret> -e GITHUB_CALLBACK_URL=<url> kdockerfiles/astral:1ec1fc6-1`
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
* If webserver is outside Docker, should add port forwarding (e.g. `-p "9000:9000"`) and volume mount (e.g. `-v /my/statics/dir/:/var/www/html/public/`) to Docker command.

# Notes
* It is switched to use SQLite as DB backend.
* Dockerfile currently contains an ad-hoc patch that disables automatic stars cache invalidation.
