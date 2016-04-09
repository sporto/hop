FROM node

ENV UPDATED_ON 2016-04-08

RUN npm install -g elm
RUN npm install elm-test

ENTRYPOINT []
