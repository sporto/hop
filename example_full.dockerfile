FROM sporto/elm-node-webpack

ENV UPDATED_ON 2016-04-08

ADD . /usr/src
WORKDIR /usr/src/examples/full

# Install elm packages
RUN ./install-packages.sh

# Make sure Elm app builds
RUN elm make ./src/Main.elm

# Install npm stuff
RUN npm i

# Make sure webpack bundle builds
RUN webpack

CMD npm run dev
