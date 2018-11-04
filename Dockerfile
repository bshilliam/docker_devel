FROM centos:7

RUN yum -y update && yum -y upgrade && yum clean all
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install ruby which openssl-devel readline-devel zlib-devel

RUN useradd -m user -p user && usermod -a -G users user

USER user

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv

RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

WORKDIR /home/user

RUN /home/user/.rbenv/bin/rbenv install 2.5.3
RUN /home/user/.rbenv/bin/rbenv rehash
RUN /home/user/.rbenv/bin/rbenv global 2.5.3
