defmodule ExUUID.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_uuid,
      version: "0.1.0",
      elixir: "~> 1.10",
      name: "ExUUID",
      description: "UUID generator according to RFC 4122",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  defp preferred_cli_env do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.github": :test,
      "coveralls.html": :test
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test, runtime: false},
      {:recode, "~> 0.5", only: :dev}
    ]
  end
end
