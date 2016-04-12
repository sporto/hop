FROM codesimple/elm:0.16

ENV UPDATED_ON 2016-04-08

# RUN apt-get update 
# RUN apt-get install -y \
#     locales

# RUN dpkg-reconfigure locales && \
#   locale-gen en_US.UTF-8 && \
#   update-locale LANG=en_US.UTF-8
# RUN locale-gen en_US.UTF-8 
# RUN dpkg-reconfigure locales

# ENV LANG en_US.UTF-8
# ENV LC_ALL en_US.UTF-8

# RUN npm i elm -g

# Add the application and install packages
ADD . /usr/src
WORKDIR /usr/src/examples/basic
RUN elm package install -y

# Make sure it compiles
RUN elm make Main.elm

CMD elm reactor
ENTRYPOINT []
