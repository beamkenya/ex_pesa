defmodule ExPesa.Mpesa.B2CTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Mpesa.B2c

  alias ExPesa.Mpesa.B2c

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
        url: "https://sandbox.safaricom.co.ke/mpesa/b2c/v1/paymentrequest",
        method: :post
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "ConversationID" => "AG_20201010_00006bd489ffcaf79e91",
            "OriginatorConversationID" => "27293-71728391-3",
            "ResponseCode" => "0",
            "ResponseDescription" => "Accept the service request successfully."
          }
        }
    end)

    :ok
  end

  describe "Mpesa B2C" do
    test "request/1 should Initiate a B2C request" do
      payment_details = %{
        command_id: "BusinessPayBill",
        amount: 10500,
        phone_number: "254722000000",
        remarks: "B2C Request"
      }

      {:ok, result} = B2c.request(payment_details)

      assert result["ResponseCode"] == "0"
    end

    test "request/1 should error out without required parameter" do
      {:error, result} = B2c.request(%{})

      "Required Parameter missing, 'command_id','amount','phone_number', 'remarks'" = result
    end
  end
end
