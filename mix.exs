defmodule ExPesa.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_pesa,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: "Payment Library For Most Public Payment API's in Kenya and hopefully Africa.",
      package: package(),
      deps: deps(),
      name: "ExPesa",
      source_url: "https://github.com/beamkenya/ex_pesa.git",
      docs: [
        # The main page in the docs
        main: "readme",
        canonical: "http://hexdocs.pm/at_ex",
        source_url: "https://github.com/beamkenya/ex_pesa.git",
        logo: "assets/logo.png",
        assets: "assets",
        extras: ["README.md", "contributing.md"]
      ]
    ]
  end

  defp package do
    [
      name: "ex_pesa",
      maintainers: ["Paul Oguda, Magak Emmanuel, Frank Midigo, Tracey Onim"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/beamkenya/ex_pesa.git",
        "README" => "https://hexdocs.pm/ex_pesa/readme.html"
      },
      homepage_url: "https://github.com/elixirkenya/africastalking-elixir"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExPesa.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.15.2"},
      {:jason, ">= 1.0.0"},
      {:timex, "~> 3.6.2"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
