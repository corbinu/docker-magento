# Docker image for Magento

This repo creates a Docker image for [Magento](http://magento.com/).

Based on
[https://github.com/mageinferno/docker-magento2-php](https://github.com/mageinferno/docker-magento2-php)
and
[https://github.com/alexcheng1982/docker-magento](https://github.com/alexcheng1982/docker-magento)

## Magento version

1.6.2.0

## How to use

### Use as standalone container

You can use `docker run` to run this image directly.

```bash
docker run -p 80:80 corbinu/magento
```

Then finish Magento installation using web UI. You need to have an existing MySQL server.

Magento is installed into `/var/www/htdocs` folder.

### Use Docker Compose

[Docker Compose](https://docs.docker.com/compose/) is the recommended way to run this image with MySQL database.

A sample `docker-compose.yml` can be found in this repo.

```yaml
version: '2'

services:
  web:
    build: .
      ports:
        - "8888:80"
    depends_on:
      - db
    env_file:
      - env

  db:
    image: mariadb:10.1.10
      ports:
        - "3306:3306"
      env_file:
        - env
      depends_on:
        - dbdata
      volumes_from:
        - dbdata

  dbdata:
    image: tianon/true
      volumes:
        - /var/lib/mysql
```

Then use `docker-compose up -d` to start MySQL and Magento server.

## Magento installation script

Installation script for Magento sample data is also provided.

Use `/usr/local/bin/mage-setup` to install sample data for Magento.

```bash
docker exec -it <container id> mage-setup
```

This script can install Magento without using web UI. This script requires certain environment variables to run:

Environment variable      | Description | Default value (used by Docker Compose - `env` file)
--------------------      | ----------- | ---------------------------
MSETUP_DB_HOST            | MySQL host  | mysql
MYSQL_DATABASE            | MySQL db name for Magento | magento
MYSQL_USER                | MySQL username | magento
MYSQL_PASSWORD            | MySQL password | magento
MAGENTO_LOCALE            | Magento locale | en_US
MAGENTO_TIMEZONE          | Magento timezone | America/New_York
MAGENTO_DEFAULT_CURRENCY  | Magento default currency | USD
MAGENTO_URL               | Magento base url | http://magento.docker
MAGENTO_ADMIN_FIRSTNAME   | Magento admin firstname | Admin
MAGENTO_ADMIN_LASTNAME    | Magento admin lastname | MyStore
MAGENTO_ADMIN_EMAIL       | Magento admin email | amdin@example.com
MAGENTO_ADMIN_USERNAME    | Magento admin username | admin
MAGENTO_ADMIN_PASSWORD    | Magento admin password | magentorocks1
MSETUP_USE_SAMPLE_DATA    | Install sample data or not | false

If Docker Compose is used, you can just modify `env` file in the same directory of `docker-compose.yml` file to update those environment variables.

After calling `mage-setup`, Magento is installed and ready to use. Use provided admin username and password to log into Magento backend.

## Magento sample data

Magento 1.9 sample data is compressed version from [Vinai/compressed-magento-sample-data](https://github.com/Vinai/compressed-magento-sample-data). Magento 1.6 uses the [official sample data](http://devdocs.magento.com/guides/m1x/ce18-ee113/ht_magento-ce-sample.data.html).

## OS X / Dinghy

To use this image on other systems for local development, create a Dockerfile with anything specific to your local development platform.

For example, if using [Dinghy](https://github.com/codekitchen/dinghy) on OS X, use:

```
FROM mageinferno/magento2-php:[TAG]
RUN usermod -u 501 www-data
```

Then build your custom image:

```
docker build -t myname/php .
```

Remember to add your `VIRTUAL_HOST` environment variable to the web server container in your docker-compose.yml file, and remove `ports` as those are automatically exposed in Dinghy.

**Important**: If you do not use the default `MAGENTO_URL` you must use a hostname that contains a dot within it (e.g `foo.bar`), otherwise the [Magento admin panel login won't work](http://magento.stackexchange.com/a/7773).
