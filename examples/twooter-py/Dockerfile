FROM debian:jessie
MAINTAINER Getty Ritter <gdritter@galois.com>

RUN apt-get -qq update
RUN apt-get -qqy install python python-pip
RUN pip install web.py
ADD application /application

EXPOSE 80
CMD run.sh /run.sh
