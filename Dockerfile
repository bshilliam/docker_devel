FROM centos:7

RUN yum -y update && yum -y upgrade && yum clean all
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install ruby

RUN useradd -m user -p user && usermod -a -G users user

USER user

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv


RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
