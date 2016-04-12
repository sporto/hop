FROM node

ENV UPDATED_ON 2016-04-08

RUN npm i elm -g
ADD . /usr/src
WORKDIR /usr/src/examples/full

# Install elm packages
RUN ./install-packages.sh

# Make sure Elm app builds
RUN elm make ./src/Main.elm

# Install npm stuff
RUN npm i

CMD npm run dev
ENTRYPOINT []
