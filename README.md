# Instructions

## Steps

1. run docker-compose
```
docker-compose up --build
```
-Note: This will start build a db and app docker image and start up a container for each

2. create databases for the rails project (in another terminal)
```
docker-compose exec app /home/user/.rbenv/shims/rails db:create
```
-You should now be able to hit http://localhost:3000 from your browser and see the Yay! You're on Rails! page.

## Other helpful commands

### login to the db from the app container
```
mysql -u root -p -h $MYSQL_PORT_3306_TCP_ADDR
```

### test db connection from app container, this should dump a file to ~/Sites/demo_project/db/schema.rb
```
cd ~/Sites/demo_project
rails db:schema:dump
```

### start rails project from the app container
```
cd ~/Sites/demo_project
rails server

```

### start a dummy container to run mysql commands against the db in the db container
```
docker run -it --link devel-db:mysql --rm devel_mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```

### login to the db container to check logs etc
```
docker exec -it docker_devel_db bash
```
