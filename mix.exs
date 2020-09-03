defmodule ExPesa.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_pesa,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: "This is a Payments Library",
      package: package(),
      deps: deps(),
      name: "ex_pesa",
      source_url: "https://github.com/beamkenya/ex_pesa.git",
      homepage_url: "https://hexdocs.pm/ex_pesa/ExPesa.html",
      docs: [
        # The main page in the docs
        main: "ex_pesa",
        # logo:
        #   "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/M-PESA_LOGO-01.svg/1200px-M-PESA_LOGO-01.svg.png",
        extras: ["README.md"]
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Beam Kenya"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/beamkenya/ex_pesa.git",
        "Documentation" => "https://hexdocs.pm/ex_pesa/ExPesa.html",
        "README" => "https://hexdocs.pm/ex_pesa/readme.html"
      }
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
