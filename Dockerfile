FROM devel_centos:latest

ENV homedir=/home/user \
    project_name=demo_project \
    username=user \
    group=users \
    ruby_version=2.5.3 \
    rbenv_hash=59785f6762e9325982584cdab1a4c988ed062020 \
    rubybuild_hash=abb1599b74a6cb68ce27bb9592f5fd2d57ec91ed

RUN useradd -m $username -p $username && usermod -a -G $group $username

USER $username

RUN set -x \
      && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
      && echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN set -x \
      && git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
      && cd $homedir/.rbenv \
      && git reset --hard $rbenv_hash \
      && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
      && cd $homedir/.rbenv/plugins/ruby-build \
      && git reset --hard $rubybuild_hash

RUN set -x \
      && $homedir/.rbenv/bin/rbenv install $ruby_version \
      && $homedir/.rbenv/bin/rbenv rehash \
      && $homedir/.rbenv/bin/rbenv global $ruby_version

RUN set -x \
      && $homedir/.rbenv/shims/gem update --system \
      && $homedir/.rbenv/shims/gem install rails --no-ri --no-rdoc

RUN mkdir $homedir/Sites

RUN set -x \
      && cd $homedir/Sites \
      && $homedir/.rbenv/shims/rails new $project_name -d mysql \
      && $homedir/.rbenv/bin/rbenv local $ruby_version

COPY --chown=user:users database.yml $homedir/Sites/$project_name/config

RUN set -x \
      && cd $homedir/Sites/$project_name \
      && $homedir/.rbenv/shims/rake db:create

WORKDIR $homedir
