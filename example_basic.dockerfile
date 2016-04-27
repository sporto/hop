FROM sporto/elm-node-webpack

ENV UPDATED_ON 2016-04-08

# Add the application and install packages
# We need to add the root of the project so
# Elm can find Hop in src
ADD . /usr/src
WORKDIR /usr/src/examples/basic
RUN ./install-packages.sh

# Make sure it compiles
RUN elm make Main.elm

CMD elm reactor
