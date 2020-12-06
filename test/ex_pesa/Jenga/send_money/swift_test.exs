defmodule ExPesa.Jenga.SendMoney.SwiftTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock

  alias ExPesa.Jenga.SendMoney.Swift

  doctest Swift

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

      %{url: "https://uat.jengahq.io/transaction/v2/remittance#swift", method: :post} ->
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

  describe "Send Money To Cross Border Banks Via Swift" do
    test "request/1 with correct params  successfully sends money" do
      request_body = %{
        source: %{countryCode: "KE", name: "John Doe", accountNumber: "0770194201783"},
        destination: %{
          type: "bank",
          countryCode: "TZ",
          name: "Pombe Mwazungu",
          branchCode: "01",
          bankCode: "112",
          accountNumber: "0740161904311"
        },
        transfer: %{
          type: "SWIFT",
          amount: "10",
          currencyCode: "KES",
          reference: "639434645740",
          date: "2020-12-02",
          description: "some remarks here"
        }
      }

      assert {:ok, result} = Swift.request(request_body)

      assert result["status"] == "SUCCESS"
    end

    test "request/1 fails when invalid params are passed" do
      assert {:error, message} = Swift.request("invalid params")

      assert message == "Required Parameters missing, check your request body"
    end
  end
end
