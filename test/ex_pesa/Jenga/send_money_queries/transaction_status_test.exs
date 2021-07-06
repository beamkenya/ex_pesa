defmodule ExPesa.Jenga.SendMoneyQueries.TransactionStatusTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Jenga.SendMoneyQueries.TransactionStatus

  alias ExPesa.Jenga.SendMoneyQueries.TransactionStatus

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

      %{url: "https://uat.jengahq.io/transaction/v2/b2c/status/query", method: :post} ->
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

  describe "Transaction Status" do
    test "request/1 fail with no parameters passed" do
      {:error, message} = TransactionStatus.request("request_details")

      assert message == "Required Parameters missing, check your request body"
    end
  end
end
