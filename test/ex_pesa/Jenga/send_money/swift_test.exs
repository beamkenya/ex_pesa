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
        source: %{countryCode: "KE", name: "John Doe", accountNumber: "0170199741045"},
        destination: %{
          type: "bank",
          countryCode: "JP",
          name: "Tom Doe",
          bankBic: "BOTKJPJTXXX",
          accountNumber: "12365489",
          addressline1: "Post Box 56"
        },
        transfer: %{
          type: "SWIFT",
          amount: "2.00",
          currencyCode: "USD",
          reference: "692194625798",
          date: "2020-12-06",
          description: "some remarks",
          chargeOption: "SELF"
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
