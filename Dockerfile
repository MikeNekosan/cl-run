# Common Lisp test
FROM centos:latest
MAINTAINER Shigeru OKUMURA <shgieru333@gmail.com>
WORKDIR /opt
RUN yum -y update
RUN yum -y install sudo ssh git gcc automake autoconf make libcurl-devel zlib-devel bzip2
RUN git clone https://github.com/roswell/roswell.git
WORKDIR /opt/roswell
RUN sudo ./bootstrap
RUN sudo ./configure
RUN sudo make
RUN sudo make install

RUN groupadd -g 1000 test && useradd -g test -G test -m -s /bin/bash test && echo 'test:test' | chpasswd
RUN echo 'Defaults visiblepw' >> /etc/sudoers
RUN echo 'test ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN sed -e 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config | sed -e 's/#UseDNS yes/UseDNS no/' > /etc/ssh/sshd_config

VOLUME /docker/cl:/cl

USER test:test
WORKDIR /cl
RUN ros setup
ENTRYPOINT ["/bin/bash"]
