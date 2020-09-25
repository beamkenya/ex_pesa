use Mix.Config
config :tesla, adapter: Tesla.Adapter.Hackney

config :ex_pesa,
  force_live_url: "NO",
  mpesa: [
    consumer_key: "72yw1nun6g1QQPPgOsAObCGSfuimGO7b",
    consumer_secret: "vRzZiD5RllMLIdLD",
    mpesa_short_code: "174379",
    c2b_short_code: "600247", # had to pass this for registerurl to work for C2B
    mpesa_passkey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
    mpesa_callback_url: "http://91eb0af5.ngrok.io/api/payment/callback"
  ]
