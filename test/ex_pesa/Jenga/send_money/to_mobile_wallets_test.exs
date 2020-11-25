defmodule ExPesa.Jenga.SendMoney.ToMobileWalletsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Jenga.SendMoney.ToMobileWallets

  alias ExPesa.Jenga.SendMoney.ToMobileWallets

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

      %{url: "https://uat.jengahq.io/transaction/v2/remittance#sendmobile", method: :post} ->
        %Tesla.Env{
          status: 200,
          body: %{
            "transactionId" => "1452854",
            "status" => "SUCCESS"
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
          type: "mobile",
          countryCode: "KE",
          name: "Tom Doe",
          mobileNumber: "0722000000",
          walletName: "Mpesa"
        },
        transfer: %{
          type: "MobileWallet",
          amount: "1000",
          currencyCode: "KES",
          reference: "639434645738",
          date: "2020-11-25",
          description: "some remarks here"
        }
      }

      {:ok, result} = ToMobileWallets.request(request_body, true)

      assert result["status"] == "SUCCESS"
    end

    test "request/1 fail with no parameters passed" do
      {:error, message} = ToMobileWallets.request("request_details")

      assert message == "Required Parameters missing, check your request body"
    end
  end
end
