import Config

config :logger,
  backends: [:console, {LoggerFileBackend, :error_log}]

config :logger, :error_log,
  path: "logs/debug.log",
  # Change this to :debug to start logging
  level: :debug

config :logger, :console, level: :info
