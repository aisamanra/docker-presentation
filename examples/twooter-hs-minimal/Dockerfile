FROM debian:jessie

RUN apt-get -qq update
RUN apt-get -qqy install libc6 libgmp10
ADD twooter-hs /bin/twooter-hs
CMD /bin/twooter-hs
