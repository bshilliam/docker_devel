# Instructions

## Steps

1. build devel_centos image
```
docker build --rm --tag devel_centos:latest docker_centos/.
```

2. build devel_mysql image

```
docker build --rm --tag devel_mysql:latest docker_mysql/.
```
- Note: The devel_mysql image is vanilla mysql with `default-authentication-plugin=mysql_native_password` and some create user sql commands. See the files in `./docker_mysql/mysql_config`

3. run devel_mysql container
```
docker run --name devel-db -e MYSQL_ROOT_PASSWORD=root -d devel_mysql
```

4. build devel image to develop and run on rails (this will take a while)
```
docker build --rm --tag devel:latest .
```

5. run development container linked to the db container and create databases
```
docker run -ti -p 3000:3000 --name devel-app --link devel-db:mysql --rm devel bash
cd ~/Sites/demo_project
rake db:create
```

## Other helpful commands

### login to the db from the devel container
```
mysql -u root -p -h $MYSQL_PORT_3306_TCP_ADDR
```

### test db connection from devel container, this should dump a file to ~/Sites/demo_project/db/schema.rb
```
cd ~/Sites/demo_project
rails db:schema:dump
```

### start rails project
```
cd ~/Sites/demo_project
rails server
```

### start a container to run mysql commands against the db in the db container
```
docker run -it --link devel-db:mysql --rm devel_mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```

### login to the db container to check logs etc
```
docker exec -it devel-db bash
```
