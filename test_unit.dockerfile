FROM node

ENV UPDATED_ON 2016-04-08

RUN apt-get update && apt-get install -y \
         locales

RUN dpkg-reconfigure locales && \
         locale-gen C.UTF-8 && \
         update-locale LANG=C.UTF-8

ENV LC_ALL C.UTF-8

RUN npm install elm -g
RUN npm install elm-test -g

ENV ELM_HOME /usr/local/lib/node_modules/elm/share


ENTRYPOINT []
