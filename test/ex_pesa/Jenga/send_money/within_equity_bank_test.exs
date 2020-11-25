defmodule ExPesa.Jenga.SendMoney.WithinEquityBankTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Jenga.SendMoney.WithinEquityBank

  alias ExPesa.Jenga.SendMoney.WithinEquityBank

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

      %{url: "https://uat.jengahq.io/transaction/v2/remittance#sendeqtybank", method: :post} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "transactionId" => "1452854",
              "status" => "SUCCESS"
            })
        }
    end)

    :ok
  end

  describe "Send Money To Within Equity Bank" do
    test "request/1 fail with no parameters passed" do
      {:error, message} = WithinEquityBank.request("request_details")

      assert message == "Required Parameters missing, check your request body"
    end
  end
end
