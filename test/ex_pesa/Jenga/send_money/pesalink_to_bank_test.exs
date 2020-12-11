defmodule ExPesa.Jenga.SendMoney.PesalinkToBankTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Jenga.SendMoney.PesalinkToBank

  alias ExPesa.Jenga.SendMoney.PesalinkToBank

  setup do
    mock(fn
      %{
        url: "https://uat.jengahq.io/identity/v2/token",
        method: :post
      } ->
        %Tesla.Env{
          status: 200,
          body: """
          {
            "access_token" : "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm",
            "expires_in" : "3599"
          }
          """
        }

      %{url: "https://uat.jengahq.io/transaction/v2/remittance#pesalinkacc", method: :post} ->
        %Tesla.Env{
          status: 200,
          body: %{
            "transactionId" => "1452854",
            "status" => "SUCCESS",
            "description" =>
              "Confirmed. Ksh 1000 Sent to 01100762802910 -Tom Doe from your account 1460163242696 on 20-05-2019 at 141313 Ref. 707700078800 Thank you"
          }
        }
    end)

    :ok
  end

  describe "Send Money To Mobile Wallets" do
    test "request/2 send money to Equitel" do
      request_body = %{
        source: %{countryCode: "KE", name: "John Doe", accountNumber: "0770194201783"},
        destination: %{
          type: "bank",
          countryCode: "KE",
          name: "Tom Doe",
          bankCode: "63",
          accountNumber: "0090207635001"
        },
        transfer: %{
          type: "PesaLink",
          amount: "100",
          currencyCode: "KES",
          reference: "639434645738",
          date: "2020-11-25",
          description: "some remarks here"
        }
      }

      {:ok, result} = PesalinkToBank.request(request_body)

      assert result["status"] == "SUCCESS"
    end

    test "request/1 fail with no parameters passed" do
      {:error, message} = PesalinkToBank.request("request_details")

      assert message == "Required Parameters missing, check your request body"
    end
  end
end
