use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hello_sockets, HelloSocketsWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
# config :logger,
#  backends: [:console],
#  compile_time_purge_level: :debug

config :statix, HelloSockets.Statix, port: 8127
