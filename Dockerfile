# Extend from official Elixir image
FROM elixir:latest

# Create app directory and copy the Elixir project into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install Hex package manager
# By using --force, we don't need to type "Y"
RUN mix local.hex --force

# Compile the project
RUN mix do compile

CMD ["mix", "phx.server"]]
EXPOSE 4000