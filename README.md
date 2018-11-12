# Full Web Stack Docker [![Build Status](https://travis-ci.org/nanoninja/docker-nginx-php-mysql.svg?branch=master)](https://travis-ci.org/nanoninja/docker-nginx-php-mysql) [![GitHub version](https://badge.fury.io/gh/nanoninja%2Fdocker-nginx-php-mysql.svg)](https://badge.fury.io/gh/nanoninja%2Fdocker-nginx-php-mysql)

This was origionally a clone of Nanoninja's [docker-nginx-php-mysql](https://github.com/nanoninja/docker-nginx-php-mysql). A docker-compose setup that was developed to have a full web stack for developers to get up an running quickly. This project is still in development, but for the most part is good to go. This is by no means a lightweight stack; it was designed to removie the heavy lifting


### Images Used

* [Nginx w\ Node](https://hub.docker.com/r/rihoj/nginxnode/)
    * This is the web server which will host your code.
* [PHP-FPM](https://hub.docker.com/r/nanoninja/php-fpm/)
    * PHP server.
* [Composer](https://hub.docker.com/_/composer/)
    * Composer for all your dependencies.
* [MailHog](https://hub.docker.com/r/mailhog/mailhog/)
    * Gotta trap them all (emails that is).
* [PHPMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)
    * Easy GUI access for mysql.
* [MySQL](https://hub.docker.com/_/mysql/)
    * MySQL server.
* [Redis](https://hub.docker.com/_/redis/)
    * Redis server (I use this for cache and sessions)
* [LocalStack](https://hub.docker.com/r/localstack/localstack/)
    * AWS for local development.
    * Currently I am only supporting S3 and SQS.
* [AWS-CLI](https://hub.docker.com/r/mesosphere/aws-cli/)
    * CLI to access localstack.
    * For the endpoint please use the LOCALSTACK_HOST from the .env
* [DNS Proxy Server](https://hub.docker.com/r/defreitas/dns-proxy-server/)
    * Used in conjunction with the nginx proxy server to allow easy urls.
    * During load and shutdown of this service you may see a small hiccup in your network connection. Please see [Troubleshooting](#troubleshoot)
    * If not shutdown correctly this may interrupt your network connection. Please see [Troubleshooting](#troubleshoot)
* [Nginx](https://hub.docker.com/_/nginx/)
    * Used as a proxy server.
    * Works with DNS proxy server to add SSL and hide ports on many services.
* [Generate Certificate](https://hub.docker.com/r/jacoelho/generate-certificate/)
    * Used to generate SSL certs.

## Overview

1. [Install prerequisites](#install-prerequisites)

    Before installing project make sure the following prerequisites have been met.

2. [Clone the project](#clone-the-project)

    We’ll download the code from its repository on GitHub.

3. [Setup Env](#setup-the-environment)

    This docker compose file works heavily off of the .env file. We will get it setup and ready to go.

4. [Setup SSL Certificates](#setup-ssl-certificates) [`Required`]

    We'll generate and configure SSL certificate for nginx before running server.

5. [Configure Xdebug](#configure-xdebug) [`Optional`]

    We'll configure Xdebug for IDE (PHPStorm or Netbeans).

6. [Run the application](#run-the-application)

    By this point we’ll have all the project pieces in place.

7. [Use Makefile](#use-makefile) [`Optional`]

    When developing, you can use `Makefile` for doing recurrent operations.

8. [Use Docker Commands](#use-docker-commands)

    When running, you can use docker commands for doing recurrent operations.

___

## Install prerequisites

For now, this project has been mainly created for Unix `(Linux/MacOS)`.

### Tested and approved OSes
1. `Linux Mint 18.1 Serena`

I will try to test and add more OSes to this list, but I can not verify any MacOS. If you can, please create a PR updating this list.

All requisites should be available for your distribution. The most important are :

* [Git](https://git-scm.com/downloads)
* [Docker](https://docs.docker.com/engine/installation/)
* [Docker Compose](https://docs.docker.com/compose/install/)

Check if `docker-compose` is already installed by entering the following command :

```sh
which docker-compose
```

Check Docker Compose compatibility :

* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)

The following is optional but makes life more enjoyable :

```sh
which make
```

On Ubuntu and Debian these are available in the meta-package build-essential. On other distributions, you may need to install the GNU C++ compiler separately.

```sh
sudo apt install build-essential
```
___

## Clone the project

To install [Git](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git), download it and install following the instructions :

```sh
git clone https://github.com/rihoj/docker-full-stack.git
```

Go to the project directory :

```sh
cd docker-full-stack
```
___

## Setup the environment

There are two steps to setting up your environment

1. Edit `/etc/hosts` file
    ```sh
    # Add the following line to the file.
    127.0.0.2       rp.io
    ```
    It is important to know what you are doing in this file. The rp.io can be changed to your prefered domain. This will be referenced in the `.env` file.

2. Edit `.env` file

    I have tried to explain everything in the env. Please see that file.

___

## Setup SSL Certificates

1. Generate SSL certificates

    ```sh
    source .env && sudo docker run --rm -v $(pwd)/conf/ssl:/certificates -e "SERVER=*.$ROOT_DOMAIN" jacoelho/generate-certificate
    ```
    or
    ```sh
    make gen-certs
    ```

___

## Configure Xdebug
#### This is a legacy section from Nanoninja. I do not use xdebug and have not been able to test this yet.

If you use another IDE than [PHPStorm](https://www.jetbrains.com/phpstorm/) or [Netbeans](https://netbeans.org/), go to the [remote debugging](https://xdebug.org/docs/remote) section of Xdebug documentation.

For a better integration of Docker to PHPStorm, use the [documentation](https://github.com/nanoninja/docker-nginx-php-mysql/blob/master/doc/phpstorm-macosx.md).

1. Get your own local IP address :

    ```sh
    sudo ifconfig
    ```

2. Edit php file `etc/php/php.ini` and comment or uncomment the configuration as needed.

3. Set the `remote_host` parameter with your IP :

    ```sh
    xdebug.remote_host=192.168.0.1 # your IP
    ```
___

## Run the application

1. Start the application :

    ```sh
    sudo docker-compose up -d
    ```

    **Please wait this might take a several minutes...**

    ```sh
    sudo docker-compose logs -f # Follow log output
    ```

2. Open your favorite browser :

    Access your sites with the following logic:
    https://$X_DOMAIN.$ROOT_DOMAIN

    I.E. for the phpmyadmin service you would to go to:
    [https://phpmyadmin.rp.io](https://phpmyadmin.rp.io)

3. Stop and clear services

    ```sh
    sudo docker-compose down -v
    ```

___

## Use Makefile
#### Some of these are still legacy and may not work at this time.

When developing, you can use [Makefile](https://en.wikipedia.org/wiki/Make_(software)) for doing the following operations :

| Name          | Description                                  |
|---------------|----------------------------------------------|
| apidoc        | Generate documentation of API                |
| clean         | Clean directories for reset                  |
| code-sniff    | Check the API with PHP Code Sniffer (`PSR2`) |
| composer-up   | Update PHP dependencies with composer        |
| docker-start  | Create and start containers                  |
| docker-stop   | Stop and clear all services                  |
| gen-certs     | Generate SSL certificates for `nginx`        |
| logs          | Follow log output                            |
| mysql-dump    | Create backup of all databases               |
| mysql-restore | Restore backup of all databases              |
| phpmd         | Analyse the API with PHP Mess Detector       |
| test          | Test application with phpunit                |

### Known working Makefile Commands

| Name          | Description                                  |
|---------------|----------------------------------------------|
| gen-certs     | Generate SSL certificates for `nginx`        |
| docker-start  | Create and start containers                  |
| docker-stop   | Stop and clear all services                  |

### Warning!
`make docker-stop` will clear your data.

### Examples

Start the application :

```sh
sudo make docker-start
```

Show help :

```sh
make help
```

___

## Use Docker commands
#### This is a legacy section and may need updated.

### Installing package with composer

```sh
sudo docker run --rm -v $(pwd)/web/app:/app composer require symfony/yaml
```

### Updating PHP dependencies with composer

```sh
sudo docker run --rm -v $(pwd)/web/app:/app composer update
```

### Generating PHP API documentation

```sh
sudo docker-compose exec -T php php -d memory_limit=256M -d xdebug.profiler_enable=0 ./app/vendor/bin/apigen generate app/src --destination ./app/doc
```

### Testing PHP application with PHPUnit

```sh
sudo docker-compose exec -T php ./app/vendor/bin/phpunit --colors=always --configuration ./app
```

### Fixing standard code with [PSR2](http://www.php-fig.org/psr/psr-2/)

```sh
sudo docker-compose exec -T php ./app/vendor/bin/phpcbf -v --standard=PSR2 ./app/src
```

### Checking the standard code with [PSR2](http://www.php-fig.org/psr/psr-2/)

```sh
sudo docker-compose exec -T php ./app/vendor/bin/phpcs -v --standard=PSR2 ./app/src
```

### Analyzing source code with [PHP Mess Detector](https://phpmd.org/)

```sh
sudo docker-compose exec -T php ./app/vendor/bin/phpmd ./app/src text cleancode,codesize,controversial,design,naming,unusedcode
```

### Checking installed PHP extensions

```sh
sudo docker-compose exec php php -m
```

### Handling database

#### MySQL shell access

```sh
sudo docker exec -it mysql bash
```

and

```sh
mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD"
```

#### Creating a backup of all databases

```sh
mkdir -p data/db/dumps
```

```sh
source .env && sudo docker exec $(sudo docker-compose ps -q mysqldb) mysqldump --all-databases -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" > "data/db/dumps/db.sql"
```

#### Restoring a backup of all databases

```sh
source .env && sudo docker exec -i $(sudo docker-compose ps -q mysqldb) mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" < "data/db/dumps/db.sql"
```

#### Creating a backup of single database

**`Notice:`** Replace "YOUR_DB_NAME" by your custom name.

```sh
source .env && sudo docker exec $(sudo docker-compose ps -q mysqldb) mysqldump -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" --databases YOUR_DB_NAME > "data/db/dumps/YOUR_DB_NAME_dump.sql"
```

#### Restoring a backup of single database

```sh
source .env && sudo docker exec -i $(sudo docker-compose ps -q mysqldb) mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" < "data/db/dumps/YOUR_DB_NAME_dump.sql"
```


#### Connecting MySQL from [PDO](http://php.net/manual/en/book.pdo.php)

```php
<?php
    try {
        $dsn = 'mysql:host=mysql.io;dbname=test;charset=utf8;port=3306';
        $pdo = new PDO($dsn, 'dev', 'dev');
    } catch (PDOException $e) {
        echo $e->getMessage();
    }
?>
```

___

## Help us

I welcome any thoughts, feedback, or bugs! Please create an issue and I will get to it as soon as possible!

___

## TODO

1. Move the web directory into the repository.

2. Update makefile with accurate commands

3. Update documentation.

4. Custom roll AWS-CLI to not need endpoints.

5. Test more operating systems.
