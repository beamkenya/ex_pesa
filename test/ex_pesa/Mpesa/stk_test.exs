defmodule ExPesa.Mpesa.StkTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Mpesa.Stk

  alias ExPesa.Mpesa.Stk

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

      %{url: "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest", method: :post} ->
        %Tesla.Env{
          status: 200,
          body:
            Jason.encode!(%{
              "CheckoutRequestID" => "ws_CO_010320202011179845",
              "CustomerMessage" => "Success. Request accepted for processing",
              "MerchantRequestID" => "25558-10595705-4",
              "ResponseCode" => "0",
              "ResponseDescription" => "Success. Request accepted for processing"
            })
        }
    end)

    :ok
  end

  describe "Mpesa STK Push" do
    test "request/1 should Initiate STK with required parameters" do
      request_details = %{
        amount: 10,
        phone: "254724540000",
        reference: "reference",
        description: "description"
      }

      {:ok, result} = Stk.request(request_details)

      assert result["CheckoutRequestID"] == "ws_CO_010320202011179845"
      assert result["ResponseCode"] == "0"
    end
  end

  test "request/1 should error out without required parameter" do
    {:error, result} = Stk.request(%{})
    "Required Parameters missing, 'phone, 'amount', 'reference', 'description'" = result
  end
end
