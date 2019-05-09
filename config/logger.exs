use Mix.Config

file_backends =
  cond do
    System.get_env("LOG_LEVEL") == "debug" ->
      [
        {LoggerFileBackend, :error_log},
        {LoggerFileBackend, :warn_log},
        {LoggerFileBackend, :info_log},
        {LoggerFileBackend, :debug_log}
      ]

    System.get_env("LOG_LEVEL") == "info" ->
      [{LoggerFileBackend, :error_log}, {LoggerFileBackend, :warn_log}, {LoggerFileBackend, :info_log}]

    System.get_env("LOG_LEVEL") == "warn" ->
      [{LoggerFileBackend, :error_log}, {LoggerFileBackend, :warn_log}]

    System.get_env("LOG_LEVEL") == "error" ->
      [{LoggerFileBackend, :error_log}]

    true ->
      []
  end

config :logger,
  format: "$date $time [$level] $message\n",
#  backends: [:console, {Rollbar.ErrorSend, :error_log}] ++ file_backends
  backends: [:console] ++ file_backends

config :logger, :error_log,
  path: "log/error.log",
  format: "$date $time [$level] $message\n",
  level: :error

config :logger, :warn_log,
  path: "log/warn.log",
  format: "$date $time [$level] $message\n",
  level: :warn

config :logger, :info_log,
  path: "log/info.log",
  format: "$date $time [$level] $message\n",
  level: :info

config :logger, :debug_log,
  path: "log/debug.log",
  format: "$date $time [$level] $message\n",
  level: :debug
