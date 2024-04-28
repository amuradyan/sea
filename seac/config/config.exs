import Config

config :logger,
  backends: [{LoggerFileBackend, :error_log}]

config :logger, :error_log,
  path: "logs/debug.log",
  level: :debug
