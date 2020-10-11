defmodule ExPesa.Mpesa.ReversalTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Mpesa.Reversal

  alias ExPesa.Mpesa.Reversal

  @base_url "https://sandbox.safaricom.co.ke"

  setup do
    mock(fn
      %{
        url: "#{@base_url}/oauth/v1/generate?grant_type=client_credentials",
        method: :get
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "access_token" => "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm",
            "expires_in" => "3599"
          }
        }

      %{url: "#{@base_url}/mpesa/reversal/v1/request", method: :post} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
                "ConversationID" => "AG_20201011_00006511c0024c170286",
                "OriginatorConversationID" => "8094-41340768-1",
                "ResponseCode" => "0",
                "ResponseDescription" => "Accept the service request successfully."
            })
        }
    end)

    :ok
  end

  describe "Mpesa Reversal" do
    test "reverse/2 makes a successful request" do
      {:ok, result} = Reversal.reverse(%{amount: 30, transaction_id: "LGR013H3J2"})

      assert result["ResponseCode"] == "0"
    end

    test "reverse/2 returns an error if amount is missing" do
      {:error, result} = Reversal.reverse(%{transaction_id: "LGR013H3J2"})
      assert result =~ "either transaction_id or amount is missing from the given params"
    end

    test "reverse/2 returns an error if transaction_id is missing" do
      {:error, result} = Reversal.reverse(%{amount: 30})
      assert result =~ "either transaction_id or amount is missing from the given params"
    end
  end
end
