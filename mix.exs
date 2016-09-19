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
    [applications: [:logger]]
  end

  # Type "mix help deps" for more examples and options
  defp deps do
    [
      { :cowboy, github: "ninenines/cowboy", tag: "2.0.0-pre.3" },
      { :poison, "~> 2.0"},
      { :uuid, "~> 0.1.5" },
      { :apex, "~> 0.5.2 "},
      { :table_rex, "~> 0.8.3"}
    ]
  end
end
