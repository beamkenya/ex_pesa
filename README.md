<p align="left"><img src="assets/logo.png" width="140"></p>

[![Actions Status](https://github.com/beamkenya/ex_pesa/workflows/Elixir%20CI/badge.svg)](https://github.com/beamkenya/ex_pesa/actions) ![Hex.pm](https://img.shields.io/hexpm/v/ex_pesa) ![Hex.pm](https://img.shields.io/hexpm/dt/ex_pesa) [![Coverage Status](https://coveralls.io/repos/github/beamkenya/ex_pesa/badge.svg?branch=develop)](https://coveralls.io/github/beamkenya/ex_pesa?branch=develop)

# ExPesa :dollar: :pound: :yen: :euro:

> Payment Library For Most Public Payment API's in Kenya and hopefully Africa. Let us get this :moneybag:

## Table of contents

- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Documentation](#documentation)
- [Contribution](#contribution)
- [Contributors](#contributors)
- [Licence](#licence)

## Features

[WIP]

- [x] Mpesa
  - [x] Mpesa Express (STK)
  - [x] STK Transaction Validation
  - [x] B2C
  - [x] B2B
  - [x] C2B
  - [ ] Reversal
  - [ ] Transaction Status
  - [x] Account Balance
- [ ] JengaWS(Equity)
  - [ ] Send Money
  - [ ] Receive Payments
  - [ ] Buy Goods, Pay Bills, Get Airtime
  - [ ] Credit
  - [ ] Reg Tech: KYC, AML, & CDD API
  - [ ] Account Services
- [ ] Paypal
- [ ] Card

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

Create a copy of `config/dev.exs` or `config/prod.exs` from `config/dev.sample.exs`
Use the `sandbox` key to `true` when you are using sandbox credentials, chnage to `false` when going to `:prod`

### Mpesa (Daraja)

Mpesa Daraja API link: https://developer.safaricom.co.ke

Add below config to dev.exs / prod.exs files
This asumes you have a clear understanding of how [Daraja API works](https://developer.safaricom.co.ke/get-started).

You can also refer to this Safaricom Daraja API Tutorial: https://peternjeru.co.ke/safdaraja/ui/ by Peter Njeru

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

### Quick Examples

#### Mpesa Express (STK)

```elixir
  iex> ExPesa.Mpesa.Stk.request(%{amount: 10, phone: "254724540000", reference: "reference", description: "description"})
      {:ok,
        %{
        "CheckoutRequestID" => "ws_CO_010320202011179845",
        "CustomerMessage" => "Success. Request accepted for processing",
        "MerchantRequestID" => "25558-10595705-4",
        "ResponseCode" => "0",
        "ResponseDescription" => "Success. Request accepted for processing"
        }}
```

## Contribution

If you'd like to contribute, start by searching through the [issues](https://github.com/beamkenya/ex_pesa/issues) and [pull requests](https://github.com/beamkenya/ex_pesa/pulls) to see whether someone else has raised a similar idea or question.
If you don't see your idea listed, [Open an issue](https://github.com/beamkenya/ex_pesa/issues).

Check the [Contribution guide](contributing.md) on how to contribute.

## Contributors

Auto-populated from:
[contributors-img](https://contributors-img.firebaseapp.com/image?repo=beamkenya/ex_pesa)

<a href="https://github.com/beamkenya/ex_pesa/graphs/contributors">
  <img src="https://contributors-img.firebaseapp.com/image?repo=beamkenya/ex_pesa" />
</a>

## Licence

ExPesa is released under [MIT License](https://github.com/appcues/exsentry/blob/master/LICENSE.txt)

[![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=for-the-badge)](#)
