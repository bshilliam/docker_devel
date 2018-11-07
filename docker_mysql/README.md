# Some helpful commands

## build devel image from this Dockerfile
docker build --rm --tag devel_mysql:latest .

## run db
docker run --name devel-db -e MYSQL_ROOT_PASSWORD=root -d devel_mysql

## notes
The devel_mysql image is vanilla mysql with `default-authentication-plugin=mysql_native_password` and some create user sql commands. See the files in `./mysql_config`
