defmodule ExPesa.Mpesa.AccountBalanceTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Mpesa.AccountBalance

  alias ExPesa.Mpesa.AccountBalance

  setup do
    mock(fn
      %{
        url: "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
        method: :get
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "access_token" => "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm",
            "expires_in" => "3599"
          }
        }

      %{
        url: "https://sandbox.safaricom.co.ke/mpesa/accountbalance/v1/query",
        method: :post
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "ConversationID" => "AG_20201010_00007d6021022d396df6",
            "OriginatorConversationID" => "28290-142922216-2",
            "ResponseCode" => "0",
            "ResponseDescription" => "Accept the service request successfully."
          }
        }
    end)

    :ok
  end

  describe "Mpesa AccountBalance" do
    test "request/1 should Initiate a AccountBalance request" do
      payment_details = %{
        command_id: "AccountBalance",
        short_code: "602843",
        remarks: "remarks",
        account_type: "Customer"
      }

      {:ok, result} = AccountBalance.request(payment_details)

      assert result["ResponseCode"] == "0"
    end

    test "request/1 should error out without required parameter" do
      {:error, result} = AccountBalance.request()

      "Required Parameter missing, 'command_id','short_code', 'remarks','account_reference'" =
        result
    end
  end
end
