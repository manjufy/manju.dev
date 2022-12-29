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

  // Short cut
  $ rm -rf _build && mix deps.get --only prod && MIX_ENV=prod mix compile && MIX_ENV=prod mix assets.deploy && MIX_ENV=prod mix release
  ```

  Reference: https://hexdocs.pm/phoenix/deployment.html#handling-of-your-application-secrets

  Debian User managmenet: https://medium.com/3-elm-erlang-elixir/how-to-deploying-phoenix-application-on-ubuntu-293645f38145

## Dockerize

  ```
  docker image build -t manju.dev:latest .

  ```

## References
  
  https://blog.miguelcoba.com/deploying-a-phoenix-16-app-with-docker-and-elixir-releases
