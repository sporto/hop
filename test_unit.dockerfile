FROM codesimple/elm:0.16

ENV UPDATED_ON 2016-04-08

# Install node
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

RUN npm install elm -g
RUN npm install elm-test -g

ENTRYPOINT []
