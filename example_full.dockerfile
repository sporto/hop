FROM node

ENV UPDATED_ON 2016-04-08

RUN npm i elm -g
ADD . /usr/src
WORKDIR /usr/src/examples/full
RUN elm package install -y
RUN npm i

ENTRYPOINT ["npm", "run", "dev"]
