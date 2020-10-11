use Mix.Config
config :tesla, adapter: Tesla.Adapter.Hackney

config :ex_pesa,
  # When changed to "false" one will use the live endpoint url
  sandbox: true,
  mpesa: [
    consumer_key: "72yw1nun6g1QQPPgOsAObCGSfuimGO7b",
    consumer_secret: "vRzZiD5RllMLIdLD",
    mpesa_short_code: "174379",
    # had to pass this for registerurl to work for C2B
    c2b_short_code: "600247",
    mpesa_passkey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919",
    mpesa_callback_url: "http://91eb0af5.ngrok.io/api/payment/callback",
    cert:
      "-----BEGIN CERTIFICATE-----\nMIIGKzCCBROgAwIBAgIQDL7NH8cxSdUpl0ihH0A1wTANBgkqhkiG9w0BAQsFADBN\nMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMScwJQYDVQQDEx5E\naWdpQ2VydCBTSEEyIFNlY3VyZSBTZXJ2ZXIgQ0EwHhcNMTgwODI3MDAwMDAwWhcN\nMTkwNDA0MTIwMDAwWjBuMQswCQYDVQQGEwJLRTEQMA4GA1UEBxMHTmFpcm9iaTEW\nMBQGA1UEChMNU2FmYXJpY29tIFBMQzETMBEGA1UECxMKRGlnaXRhbCBJVDEgMB4G\nA1UEAxMXc2FuZGJveC5zYWZhcmljb20uY28ua2UwggEiMA0GCSqGSIb3DQEBAQUA\nA4IBDwAwggEKAoIBAQC78yeC/wLoZY6TJeqc4g/9eAKIpeCwEsjX09pD8ZxAGXqT\nOi7ssdIGJBPmJZNeEVyf8ocFhisCuLngJ9Z5e/AvH52PhrEFmVu2D03zSf4C+rhZ\nndEKP6G79pUAb/bemOliU9zM8xYYkpCRzPWUzk6zSDarg0ZDLw5FrtZj/VJ9YEDL\nWGgAfwExEgSN3wjyUlJ2UwI3wqQXLka0VNFWoZxUH5j436gbSWRIL6NJUmrq8V8S\naTEPz3eJHj3NOToDu245c7VKdF/KExyZjRjD2p5I+Aip80TXzKlZj6DjMb3DlfXF\nHsnu0+1uJE701mvKX7BiscxKr8tCRphL63as4dqvAgMBAAGjggLkMIIC4DAfBgNV\nHSMEGDAWgBQPgGEcgjFh1S8o541GOLQs4cbZ4jAdBgNVHQ4EFgQUzZmY7ZORLw9w\nqRbAQN5m9lJ28qMwIgYDVR0RBBswGYIXc2FuZGJveC5zYWZhcmljb20uY28ua2Uw\nDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjBr\nBgNVHR8EZDBiMC+gLaArhilodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vc3NjYS1z\naGEyLWc2LmNybDAvoC2gK4YpaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL3NzY2Et\nc2hhMi1nNi5jcmwwTAYDVR0gBEUwQzA3BglghkgBhv1sAQEwKjAoBggrBgEFBQcC\nARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAIBgZngQwBAgIwfAYIKwYB\nBQUHAQEEcDBuMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20w\nRgYIKwYBBQUHMAKGOmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2Vy\ndFNIQTJTZWN1cmVTZXJ2ZXJDQS5jcnQwCQYDVR0TBAIwADCCAQUGCisGAQQB1nkC\nBAIEgfYEgfMA8QB2AKS5CZC0GFgUh7sTosxncAo8NZgE+RvfuON3zQ7IDdwQAAAB\nZXs1FvEAAAQDAEcwRQIgBzVMkm7SNprjJ1GBqiXIc9rNzY+y7gt6s/O02oMkyFoC\nIQDBuThGlpmUKpeZoHhK6HGwB4jDMIecmKaOcMS18R2jxwB3AId1v+dZfPiMQ5lf\nvfNu/1aNR1Y2/0q1YMG06v9eoIMPAAABZXs1F8IAAAQDAEgwRgIhAIRq2XFiC+RS\nuDCYq8ICJg0QafSV+e9BLpJnElEdaSjiAiEAyiiW4vxwv4cWcAXE6FAipctyUBs6\nbE5QyaCnmNpoDiQwDQYJKoZIhvcNAQELBQADggEBAB0YoWve9Sxhb0PBS3Hc46Rf\na7H1jhHuwE+UyscSQsdJdk8uPAgDuKRZMvJPGEaCkNHm36NfcaXXFjPOl7LI1d1a\n9zqSP0xeZBI6cF0x96WuQGrI9/WR2tfxjmaUSp8a/aJ6n+tZA28eJZNPrIaMm+6j\ngh7AkKnqcf+g8F/MvCCVdNAiVMdz6UpCscf6BRPHNZ5ifvChGh7aUKjrVLLuF4Ls\nHE05qm6HNyV5eTa6wvcbc4ewguN1UDZvPWetSyfBk10Wbpor4znQ4TJ3Y9uCvsJH\n41ldblDvZZ2z4kB2UYQ7iBkPlJSxSOaFgW/GGDXq49sz/995xzhVITHxh2SdLkI=\n-----END CERTIFICATE-----\n",
    b2b: [
      short_code: "600247",
      initiator_name: "John Doe",
      password: "Safaricom133",
      timeout_url: "https://58cb49b30213.ngrok.io/b2b/timeout_url",
      result_url: "https://58cb49b30213.ngrok.io/b2b/result_url",
      security_credential:
        "kxlZ1Twlfr6xQru0GId03LbegvuTPelnz3qITkvUJxaCTQt1HaD2hN801Pgbi38x6dEq/hsanBBtfj6JbePayipE/srOyMQ61ieiO+5uHb/JX/NLi1Jy6Alvi0hKbCbq9cVwC/bZBhli7AUAtpfKVgIyXq2InNyfzXpzR8FhrbXiaMhTPJ8WleozPm5CnXe2bFlFP7K0yhCRlT+UOPl7xh0LqU23rMTj3TN/ms600c3j/m2FxQZdmY5/rdORrJeTQV1vw6kXr1QrGaSDSdRMUiaGbg5uPL8LSNwC5bn3M92oPY2cWmkyH9rOzbCN+o5+23TvweaKZlrKuv7etKXMFg=="
    ],
    b2c: [
      short_code: "600247",
      initiator_name: "John Doe",
      password: "Safaricom133",
      timeout_url: "https://58cb49b30213.ngrok.io/b2c/timeout_url",
      result_url: "https://58cb49b30213.ngrok.io/b2c/result_url"
    ],
    balance: [
      short_code: "602843",
      initiator_name: "Safaricom1",
      password: "Safaricom133",
      timeout_url: "https://58cb49b30213.ngrok.io/b2b/timeout_url",
      result_url: "https://58cb49b30213.ngrok.io/b2b/result_url",
      security_credential:
        "kxlZ1Twlfr6xQru0GId03LbegvuTPelnz3qITkvUJxaCTQt1HaD2hN801Pgbi38x6dEq/hsanBBtfj6JbePayipE/srOyMQ61ieiO+5uHb/JX/NLi1Jy6Alvi0hKbCbq9cVwC/bZBhli7AUAtpfKVgIyXq2InNyfzXpzR8FhrbXiaMhTPJ8WleozPm5CnXe2bFlFP7K0yhCRlT+UOPl7xh0LqU23rMTj3TN/ms600c3j/m2FxQZdmY5/rdORrJeTQV1vw6kXr1QrGaSDSdRMUiaGbg5uPL8LSNwC5bn3M92oPY2cWmkyH9rOzbCN+o5+23TvweaKZlrKuv7etKXMFg=="
    ],
    transaction_status: [
      initiator_name: "John Doe",
      password: "Safaricom133",
      timeout_url: "https://58cb49b30213.ngrok.io/transaction/timeout_url",
      result_url: "https://58cb49b30213.ngrok.io/transaction/result_url",
      security_credential: ""
    ],
    reversal: [
      short_code: "600247",
      initiator_name: "Jane Doe",
      password: "superStrong@1",
      timeout_url: "https://58cb49b30213.ngrok.io/reversal/timeout_url",
      result_url: "https://58cb49b30213.ngrok.io/reversal/result_url",
      security_credential:
        "kxlZ1Twlfr6xQru0GId03LbegvuTPelnz3qITkvUJxaCTQt1HaD2hN801Pgbi38x6dEq/hsanBBtfj6JbePayipE/srOyMQ61ieiO+5uHb/JX/NLi1Jy6Alvi0hKbCbq9cVwC/bZBhli7AUAtpfKVgIyXq2InNyfzXpzR8FhrbXiaMhTPJ8WleozPm5CnXe2bFlFP7K0yhCRlT+UOPl7xh0LqU23rMTj3TN/ms600c3j/m2FxQZdmY5/rdORrJeTQV1vw6kXr1QrGaSDSdRMUiaGbg5uPL8LSNwC5bn3M92oPY2cWmkyH9rOzbCN+o5+23TvweaKZlrKuv7etKXMFg=="
    ]
  ]
