This is my minimal `Docker` image for `Grav` website development. The image uses `Alpine Linux` and `PHP8`. I use `Ubuntu Linux` so this image was not tested in `Windows` and `Mac`.

Suggestions are always welcome!

## Usage

Replace `docker compose` command below with `docker-compose` if you have `docker-compose` on your system.

### Configurations

You can customize the configuration of `Nginx` in `/server/etc/nginx` and `PHP` in `/server/php`.

If your Linux user ID is not `1000`, edit `Dockerfile` and replace `1000` with your ID.

### Grav data

Copy the content of your Grav's `user` folder to `grav` folder.

The latest version of Grav is used so ensure that your plugins are also in the latest versions.

Grav is installed in `/usr/share/nginx/html` in Docker image.

### Build image

    ./build.sh

or

    docker compose build --no-cache

### Start container

    ./up.sh

or

    docker compose up -d

The site can be accessed at `http://localhost:8080`.

### Stop container

    ./down.sh

or

    docker compose down

### Other scripts:

* `log.sh`: view container's log
* `exec.sh`: start a Bash shell in container

