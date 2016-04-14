FROM codesimple/elm:0.16

ENV UPDATED_ON 2016-04-08

# Install node
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

ADD . /usr/src
WORKDIR /usr/src/examples/full

# Install elm packages
RUN ./install-packages.sh

# Make sure Elm app builds
RUN elm make ./src/Main.elm

# Install npm stuff
RUN npm install webpack -g
RUN npm i

# Make sure webpack bundle builds
RUN webpack

CMD npm run dev
ENTRYPOINT []
