FROM haskell:7.8
MAINTAINER Getty Ritter <gdritter@galois.com>

RUN cabal update

ADD build/twooter-hs.cabal /build/twooter-hs.cabal
RUN cd /build && cabal install --only-dependencies -j4

ADD build /build
RUN cd /build && cabal install
ENV PATH /.cabal/bin:$PATH

EXPOSE 80
CMD twooter-hs
