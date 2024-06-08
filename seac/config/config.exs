import Config

if Mix.env() in [:dev, :test] do
  config :mix_test_watch,
    extra_extensions: [".sea"]
end

config :logger,
  backends: [:console, {LoggerFileBackend, :error_log}]

config :logger, :error_log,
  path: "logs/debug.log",
  # Change the level to :debug to start logging
  level: :info

config :logger, :console,
  # Change the level to :debug to start logging
  level: :info
