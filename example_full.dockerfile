FROM sporto/elm-node-webpack

ENV UPDATED_ON 2016-04-08

ADD . /usr/src
WORKDIR /usr/src/examples/full

# Install elm packages
RUN ./install-packages.sh
