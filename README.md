# manju.dev

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4001`](http://localhost:4001) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Production Deployment

  ```
  $ mix phx.gen.secret
  $ export SECRET_KEY_BASE=<KEY>
  // Initial setup
  $ mix deps.get --only prod
  $ MIX_ENV=prod mix compile
  // Compile assets
  $ MIX_ENV=prod mix assets.deploy
  // Run the server
  $ PORT=4001 MIX_ENV=prod SECRET_KEY_BASE=$(mix phx.gen.secret)  mix phx.server


  // Release
  $ MIX_ENV=prod mix release

  // Short cut to run it locally. Then access it through http://localhost:4001
  $ rm -rf _build && mix deps.get --only prod && MIX_ENV=prod mix compile && MIX_ENV=prod mix assets.deploy && MIX_ENV=prod mix release
  ```

  Reference: https://hexdocs.pm/phoenix/deployment.html#handling-of-your-application-secrets

  Debian User managmenet: https://medium.com/3-elm-erlang-elixir/how-to-deploying-phoenix-application-on-ubuntu-293645f38145

## Dockerize with debian (Dockerfile)

  `Dockerfile` is based on the debian bullseye slim image 

  ```
  docker image build -t elixir/portal .

  docker run -e SECRET_KEY_BASE="$(mix phx.gen.secret)" -p  4001:4000 elixir/portal
  ```

## Dockerize with alpine (Dockerfile.alpine)

  `Dockerfile.alpine` is based on the debian bullseye slim image 

  ```
  docker image build -t elixir.alpine/portal . --no-cache -f Dockerfile.alpine

  docker run -e SECRET_KEY_BASE="$(mix phx.gen.secret)" -p  4001:4000  elixir.alpine/portal
  ```

## Useful commands

  ```
  // 1. Stop running containers
  // 2. Remove the container
  // 3. Remove the image
  docker stop $(docker ps -a | grep elixir | awk '{print $1}') \
  && docker rm $(docker ps -a | grep elixir | awk '{print $1}') \
  && docker image rm $(docker images | grep elixir | awk '{print $3}')
  ```

## References
  
  Mix Release Reference: https://hexdocs.pm/phoenix/releases.html

  Elixir Release blog: https://blog.miguelcoba.com/deploying-a-phoenix-16-app-with-docker-and-elixir-releases
