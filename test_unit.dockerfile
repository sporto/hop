FROM node

ENV UPDATED_ON 2016-04-08

RUN npm install elm -g
RUN npm install elm-test -g

ENTRYPOINT []
