##### [badges][badges]

# ExPesa :dollar: :pound: :yen: :euro:

> Payment Library For Most Public Payment API's in Kenya and hopefully Africa. Let us get this :moneybag:

## Table of contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Documentation](#documentation)
- [Contribution](#contribution)
- [Licence](#licence)

## Features

[WIP]

- [x] Mpesa
  - [x] STK push
  - [ ] B2C
  - [ ] B2B
  - [ ] C2B
- [ ] JengaWS(Equity)
  - [ ] Send Money
  - [ ] Receive Payments
  - [ ] Buy Goods, Pay Bills, Get Airtime
  - [ ] Credit
  - [ ] Reg Tech: KYC, AML, & CDD API
  - [ ] Account Services
  
- [ ] Paypal

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_pesa` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_pesa, "~> 0.1.0"}
  ]
end
```

## Configuration

Create a copy of `config/dev.exs` or `config/prod.exs` form `config/dev.sample.exs`

### Mpesa (Daraja)

Add below config to dec.exs / prod.exs files
This asumes you have a clear understanding of how Daraja API works.

```elixir
config :ex_pesa,
    mpesa: [
        consumer_key: "72yw1nun6g1QQPPgOsAObCGSfuimGO7b",
        consumer_secret: "vRzZiD5RllMLIdLD",
        mpesa_short_code: "174379",
        mpesa_passkey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
        mpesa_callback_url: "http://91eb0af5.ngrok.io/api/payment/callback"
    ]
```

## Documentation

The docs can be found at [https://hexdocs.pm/ex_pesa](https://hexdocs.pm/ex_pesa).

## Contribution

If you'd like to contribute, start by searching through the [issues](https://github.com/beamkenya/ex_pesa/issues) and [pull requests](https://github.com/beamkenya/ex_pesa/pulls) to see whether someone else has raised a similar idea or question.
If you don't see your idea listed, [Open an issue](https://github.com/beamkenya/ex_pesa/issues).

Check the [Contribution guide](contributing.md) on how to contribute.

## Licence

ExPesa is released under [MIT License](https://github.com/appcues/exsentry/blob/master/LICENSE.txt)

[![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=for-the-badge)](#)
