import Config

config :logger,
  backends: [:console, {LoggerFileBackend, :error_log}]

config :logger, :error_log,
  path: "logs/debug.log",
  level: :debug # Change this to :debug to start logging

config :logger, :console,
  level: :info
