FROM node

ENV UPDATED_ON 2016-04-08

RUN npm i elm -g
ADD . /usr/src
WORKDIR /usr/src/examples/basic
RUN elm package install -y

ENTRYPOINT ["elm", "reactor"]
