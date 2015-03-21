FROM fedora:21
MAINTAINER Michal Jurosz <docker@mj41.cz>

RUN yum update -y \
  && yum install -y perl make gcc curl tar gzip git perl-autodie perl-Test-Harness \
  && yum clean all

RUN useradd urak
WORKDIR /home/urak/

COPY cache/* /home/urak/cache/
RUN chmod -R a+rw /home/urak/cache/
COPY dockerfile-bin/* /home/urak/dockerfile-bin/

USER urak
ENV HOME /home/urak
RUN mkdir -p /home/urak/rakudo-install/
RUN /home/urak/dockerfile-bin/all.sh release 2015.02 /home/urak/rakudo-install

USER root
RUN rm -rf /tmp/* /var/tmp/* /home/urak/dockerfile-bin /home/urak/cache

USER urak
ENV PATH $PATH:/home/urak/rakudo-install/bin:/home/urak/rakudo-install/languages/perl6/site/bin
RUN perl6 -e'say "{$*PERL.compiler.gist} on {$*VM.gist} for {$*DISTRO.gist}"'
CMD /bin/bash
