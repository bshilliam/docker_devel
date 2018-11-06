#start a mysql container
docker run --name devel-db -e MYSQL_ROOT_PASSWORD=root -d mysql

docker run --name devel-db -e MYSQL_ROOT_PASSWORD=root -d --entrypoint 'usr/local/bin/docker-entrypoint.sh' mysql --default-authentication-plugin=mysql_native_password

#start a development container linked to the db container
docker run -ti --name devel-app --link devel-db:mysql --rm devel bash

#login to the db
mysql -u root -p -h $MYSQL_PORT_3306_TCP_ADDR


#commands to start a new project
cd ~/Sites && rails new demo_project -d mysql && rbenv local 2.5.3

#configure db username,password,host
vi ~/Sites/config/database.yaml

#username: rails_user
#password: password
#host: 172.17.0.2

#test db connection, this should dump a file to ~/Sites/demo_project/db/schema.rb
cd ~/Sites/demo_project
rails db:schema:dump

#start a container to run mysql against the db in the db container
docker run -it --link devel-db:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

#start a dummy shell container to check env variables that come with a --link
docker run -it --link devel-db:mysql --rm mysql bash

#login to the db container
docker exec -it devel-db bash

#create dbs and users
create database demo_project_development;
create database demo_project_test;
create user 'rails_user' identified by 'password';
grant all privileges on demo_project_development.* to 'rails_user';
grant all privileges on demo_project_test.* to 'rails_user';