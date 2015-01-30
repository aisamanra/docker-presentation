FROM debian:jessie
MAINTAINER Getty Ritter <gdritter@galois.com>

RUN apt-get -qq update
RUN apt-get -qqy install guile-2.0

ADD hello.scm /hello.scm

CMD guile /hello.scm
