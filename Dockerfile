FROM node:5

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN npm i -g elm@0.15.1
ENV APP_DIR /usr/src
WORKDIR $APP_DIR
