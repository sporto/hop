FROM node

ENV UPDATED_ON 2016-04-08

RUN apt-get update 
RUN apt-get install -y \
    locales

RUN dpkg-reconfigure locales && \
  locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN npm i elm -g
ADD . /usr/src
WORKDIR /usr/src/examples/basic
RUN elm package install -y

ENTRYPOINT ["elm", "reactor"]
