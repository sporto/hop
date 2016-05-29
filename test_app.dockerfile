FROM sporto/elm-node-webpack

ENV UPDATED_ON 2016-05-29

ENV SRC_DIR /usr/src

WORKDIR $SRC_DIR/examples/test
COPY ./examples/test/elm-package.json $SRC_DIR/examples/test
COPY ./examples/test/package.json $SRC_DIR/examples/test
COPY ./examples/test/install-packages.sh $SRC_DIR/examples/test

# Install npm stuff
RUN npm i

# Install elm packages
RUN ./install-packages.sh

ADD . $SRC_DIR

# Make sure Elm app builds
RUN elm make ./src/Main.elm

# Make sure webpack bundle builds
RUN webpack

CMD npm run dev
