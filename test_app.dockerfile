FROM codesimple/elm:0.16

ENV UPDATED_ON 2016-05-29

# Install node
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

# Install Webpack and Elm test
RUN npm install webpack -g
RUN npm install elm-test -g

ENTRYPOINT []

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
