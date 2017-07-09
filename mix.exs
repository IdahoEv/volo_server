defmodule VoloServer.Mixfile do
  use Mix.Project

  def project do
    [app: :volo_server,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [ mod: { VoloServer, [] },
      applications:
      [ :logger,
        :cowboy,
        :ranch,
        :gproc
      ]
    ]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [
      { :cowboy, github: "ninenines/cowboy", tag: "2.0.0-pre.3" },
      { :poison, "~> 2.0"},
      { :uuid, "~> 1.1" },
      { :apex, "~> 1.0.0 "},
      { :table_rex, "~> 0.8.3"},
      { :gproc, "~> 0.6.1"},

      # Dev
      { :mix_test_watch, "~> 0.2", only: :dev},
      { :ex_doc, "~> 0.12", only: :dev },

      # Test
      { :excoveralls, "~> 0.5", only: :test },
      { :triq, github: "triqng/triq", only: :test},
      { :ex_spec, ">= 0.0.0", only: :test }
    ]
  end
end
