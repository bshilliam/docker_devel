FROM centos:7

RUN set -x \
      && yum -y update && yum -y upgrade && yum clean all \
      && yum -y groupinstall 'Development Tools' \
      && yum -y install ruby which openssl-devel openssl readline-devel zlib-devel sqlite-devel mysql-devel mysql epel-release \
      && yum -y install nodejs
