FROM centos:7

ENV homedir=/home/user \
    project_name=demo_project \
    username=user \
    group=users

RUN useradd -m $username -p $username && usermod -a -G $group $username

RUN set -x \
      && yum -y update && yum -y upgrade && yum clean all \
      && yum -y groupinstall 'Development Tools' \
      && yum -y install ruby which openssl-devel readline-devel zlib-devel sqlite-devel mysql-devel mysql epel-release \
      && yum -y install nodejs

USER $username

RUN set -x \
      && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
      && echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN set -x \
      && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
      && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

RUN set -x \
      && $homedir/.rbenv/bin/rbenv install 2.5.3 \
      && $homedir/.rbenv/bin/rbenv rehash \
      && $homedir/.rbenv/bin/rbenv global 2.5.3

RUN set -x \
      && $homedir/.rbenv/shims/gem update --system \
      && $homedir/.rbenv/shims/gem install rails --no-ri --no-rdoc

RUN mkdir $homedir/Sites

RUN set -x \
      && cd $homedir/Sites \
      && $homedir/.rbenv/shims/rails new $project_name -d mysql \
      && $homedir/.rbenv/bin/rbenv local 2.5.3

COPY --chown=user:users database.yml $homedir/Sites/$project_name/config

WORKDIR $homedir
