FROM elixir:1.5
ENV DEBIAN_FRONTEND=noninteractive

# Install hex
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# Install the Phoenix framework itself
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force

# Install NodeJS 6.x and the NPM
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y -q nodejs && \
    apt-get install inotify-tools -y && \
    apt-get clean

# Set /app as workdir
RUN mkdir /app
ADD . /app
WORKDIR /app

## Set Evn to Prod
ENV MIX_ENV=prod
ENV PORT=4001

## Node install and brunch build
WORKDIR /app/assets
RUN npm install --save react react-dom babel-preset-react && npm install brunch --global

# Compile assets
WORKDIR /app
RUN mix deps.get --only dev && \
    mix compile && \
    mix phx.digest

#RUN mix ecto.migrate

#CMD mix phx.server
