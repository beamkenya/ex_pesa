defmodule ExPesa.Mpesa.B2BTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Mpesa.B2B

  alias ExPesa.Mpesa.B2B

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
        url: "https://sandbox.safaricom.co.ke/mpesa/b2b/v1/paymentrequest",
        method: :post
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "ConversationID" => "AG_20200927_00007d4c98884c889b25",
            "OriginatorConversationID" => "27274-37744848-4",
            "ResponseCode" => "0",
            "ResponseDescription" => "Accept the service request successfully."
          }
        }
    end)

    :ok
  end

  describe "Mpesa B2B" do
    test "request/1 should Initiate a B2B request" do
      payment_details = %{
        command_id: "BusinessPayBill",
        amount: 10500,
        receiver_party: 600_000,
        remarks: "B2B Request",
        account_reference: "BILL PAYMENT"
      }

      {:ok, result} = B2B.request(payment_details)

      assert result["ResponseCode"] == "0"
    end

    test "request/1 should error out without required parameter" do
      {:error, result} = B2B.request(%{})

      "Required Parameter missing, 'command_id','amount','receiver_party', 'remarks'" = result
    end
  end
end
