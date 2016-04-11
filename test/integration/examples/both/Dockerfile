FROM elixir

ENV UPDATED_ON 2016-04-08

RUN apt-get update

RUN apt-get install -y netcat

RUN mix do local.rebar --force
RUN mix local.hex --force

