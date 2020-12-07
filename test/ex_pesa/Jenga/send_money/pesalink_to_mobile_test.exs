defmodule ExPesa.Jenga.SendMoney.PesalinkToMobileTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Jenga.SendMoney.PesalinkToMobile

  alias ExPesa.Jenga.SendMoney.PesalinkToMobile

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

      %{url: "https://uat.jengahq.io/transaction/v2/remittance#pesalinkmobile", method: :post} ->
        %Tesla.Env{
          status: 200,
          body: %{
            "transactionId" => "10000345333355",
            "status" => "SUCCESS"
          }
        }
    end)

    :ok
  end

  describe "Send Money From Pesalink to Mobile Number" do
    test "request/2 send money to Mobile" do
      request_body = %{
        source: %{countryCode: "KE", name: "John Doe", accountNumber: "0770194201783"},
        destination: %{
          type: "bank",
          countryCode: "KE",
          name: "Jane Doe",
          bankCode: "07",
          mobileNumber: "0722000000"
        },
        transfer: %{
          type: "PesaLink",
          amount: "1000",
          currencyCode: "KES",
          reference: "639434645738",
          date: "2020-11-25",
          description: "some money on the way"
        }
      }

      {:ok, result} = PesalinkToMobile.request(request_body)

      assert result["status"] == "SUCCESS"
    end

    test "request/1 fail with no parameters passed" do
      {:error, message} = PesalinkToMobile.request("request_details")

      assert message == "Required Parameters missing, check your request body"
    end
  end
end
