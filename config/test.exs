use Mix.Config
config :tesla, adapter: Tesla.Mock

config :ex_pesa,
  sandbox: true,
  mpesa: [
    consumer_key: "72yw1nun6g1QQPPgOsAObCGSfuimGO7b",
    consumer_secret: "vRzZiD5RllMLIdLD",
    mpesa_short_code: "174379",
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
      #   Leace blank to increase util test coverage
      security_credential: ""
    ],
    b2c: [
      short_code: "600247",
      initiator_name: "John Doe",
      password: "Safaricom133",
      timeout_url: "https://58cb49b30213.ngrok.io/b2c/timeout_url",
      result_url: "https://58cb49b30213.ngrok.io/b2c/result_url"
    ],
    balance: [
      short_code: "600247",
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
      security_credential:
        "kxlZ1Twlfr6xQru0GId03LbegvuTPelnz3qITkvUJxaCTQt1HaD2hN801Pgbi38x6dEq/hsanBBtfj6JbePayipE/srOyMQ61ieiO+5uHb/JX/NLi1Jy6Alvi0hKbCbq9cVwC/bZBhli7AUAtpfKVgIyXq2InNyfzXpzR8FhrbXiaMhTPJ8WleozPm5CnXe2bFlFP7K0yhCRlT+UOPl7xh0LqU23rMTj3TN/ms600c3j/m2FxQZdmY5/rdORrJeTQV1vw6kXr1QrGaSDSdRMUiaGbg5uPL8LSNwC5bn3M92oPY2cWmkyH9rOzbCN+o5+23TvweaKZlrKuv7etKXMFg=="
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
  ],
  jenga: [
    api_key: "N2RJd0FvTjB3TWVSR0ZUQUdHQkRVNG1sRHF4b1g2OWU6ejNUYzRoZmdhOEFmZ2hh",
    username: "00860091",
    password: "cE70aUkn6fzwhBLWpZXcuWa2tSjHq",
    private_key: "-----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAoOFMXt5HYwoEzj8YURznYrKDoLSDGsp6kd9UmBOsg84UKt/z
    BJUvlg/Y7v86l0bd9TMjPiVoQE7DoIJpG8xgX8BX837/cgpt3o7UGqOXNu9plEoo
    bSc+SACMtLu6+9tve7aTigaO8bSs6EplBYI6Ol0JFoeKlE8CEZ02J0XafumpObiE
    03kCqrEwxeb2QWybfKh0evAweqUi1vlMncDE0X2dqOsQY/zQEWJRxGR8WW9ziudT
    w01x434EWHirTju/GPKdT/aLa6Ki5dXGHZLojiF+qbUfKg1Og8fw25yU8hKJSxR+
    039mD15vQKIrG8TXMK+t5/f9hbXaPwey5NXrEwIDAQABAoIBAHLyJmfN90FrAh3+
    dLhXp3ccRvHGp7m3m7Wn1MBHpkYSMtSjZ/YJRZO5RO0WDN3TM3kjDXY0sfTokduX
    8dN7xgwD2JNQVOE9VFzkveU+pycIDe52wcWjeVtmkSH8089pbJD+1RGUOAO4bKYX
    qXAzKLlUic7ADyKCBN9i7TNINKHh3Ne7v+Y7pmF+uWzn2zS3r3zAm5Z6hO7K7bSP
    CwlB0KlFK2tZU8r53kWjopwAFXmTB8BvsoqA0htoDLEB3M+5+1Rn0bA1QR7TSub4
    kKqHROgbWg1ijYGG85ZV8t7spisBDOA+rZzpmW5bE6ynsJO8+cDpwSRT01a3NXHu
    IddZcFECgYEA05C/guzjTl29cMqeiS4q63wGegb2r1CeIIs/HygHJCKMXhkm6kR9
    nrZ3xmAsupkxGYyj58kJtXrc9ZBQ2VWRSiBDW/4ilCP6wX4VucxAJsrIZsNSRnkW
    uVuYkxqKyj1qBFkIqowjcL7Gu8wK9W8fhNhwgdsig7z/+WA3DVIFGQkCgYEAwqtZ
    AH2DiJb+TrWbmlh+TQRdxKOl0P/diEbmsB+bbXBtIACVIWoFiTyu6xGghBxMAx91
    IR69UofE7WH0bgoO2wqRHp/3DAQ0giZAQU91lfgSax9gxP+DT/O4HB23/NdsO8mp
    ppCGbkgT0marVUGAsyydsvUbSEU6RTgsNOXndjsCgYB3ciy99ZKsJv6S1MLHPpqa
    0y4w7QePmZt9UkC0DXxiqWLIqbiv4TVvSyO6i4gVXfI7s4zCi12A6bogpncPDWF3
    EVoWcRgCvYGQhugrOyco/6o/Yp1sDmeHBTDSNNURM7VMeRwMdgx4Vi2Lz7qMMU4B
    SdXTau5EpIt8txa93YXlSQKBgFrrjoEVHibgZtw6I/e9lxe/j0/1Is/vgPdSLhJa
    YMyHcuA8hWp6yyUiy4uMywyI7tOSkLEsWz49nTNFydTPK8sQL2E/UzIwkJms5dvb
    Ec8+ctPHbvnzYNApw3aWRsV3k9yEvpDF9ZNyZJejTihelI6aqvjXU6u4cZO8vaDj
    M+zbAoGBALzjE4PSvIFLTY01ohVHEtGT9QMbO0vLt2ROiPIzqgJSJDcOLU06Kh00
    bGUp57lUpJm212PjLeGhLLiS5Us8xHzOno8ocVKGv+CQ/xDwU6WwnCSIilZ99lyP
    uCWQAz4l8fuuWewOl4EoubO9yXWrYZ1pew/lM05wmZJE1RuIosPW
    -----END RSA PRIVATE KEY-----",
    public_key: "-----BEGIN PUBLIC KEY-----
    MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoOFMXt5HYwoEzj8YURzn
    YrKDoLSDGsp6kd9UmBOsg84UKt/zBJUvlg/Y7v86l0bd9TMjPiVoQE7DoIJpG8xg
    X8BX837/cgpt3o7UGqOXNu9plEoobSc+SACMtLu6+9tve7aTigaO8bSs6EplBYI6
    Ol0JFoeKlE8CEZ02J0XafumpObiE03kCqrEwxeb2QWybfKh0evAweqUi1vlMncDE
    0X2dqOsQY/zQEWJRxGR8WW9ziudTw01x434EWHirTju/GPKdT/aLa6Ki5dXGHZLo
    jiF+qbUfKg1Og8fw25yU8hKJSxR+039mD15vQKIrG8TXMK+t5/f9hbXaPwey5NXr
    EwIDAQAB
    -----END PUBLIC KEY-----"
  ]
