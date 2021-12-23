import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :portal, PortalWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "qssROwaLkuPv3gxSqqvst9I+ULzZO2WbSSRh5ekbEJYC44FnWGA/7sGOBQ4V2/KW",
  server: false

# In test we don't send emails.
config :portal, Portal.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
