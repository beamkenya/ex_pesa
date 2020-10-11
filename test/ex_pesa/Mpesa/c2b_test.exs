defmodule ExPesa.Mpesa.C2BTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Mpesa.C2B

  alias ExPesa.Mpesa.C2B

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
        url: "https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl",
        method: :post
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "ConversationID" => "",
            "OriginatorCoversationID" => "",
            "ResponseDescription" => "success"
          }
        }

      %{url: "https://sandbox.safaricom.co.ke/mpesa/c2b/v1/simulate", method: :post} ->
        %Tesla.Env{
          status: 200,
          body: %{
            "ConversationID" => "AG_20200921_00006e93a78f009f7025",
            "OriginatorCoversationID" => "9769-145819182-2",
            "ResponseDescription" => "Accept the service request successfully."
          }
        }
    end)

    :ok
  end

  describe "Mpesa C2B" do
    test "registerurl/1 should register a URL" do
      register_details = %{
        ConfirmationURL: "https://58cb49b30213.ngrok.io/confirmation",
        ValidationURL: "https://58cb49b30213.ngrok.io/validation",
        ResponseType: "Completed"
      }

      {:ok, result} = C2B.registerurl(register_details)

      assert result["ResponseDescription"] == "success"
    end

    test "request/1 should error out without required parameter" do
      {:error, result} = C2B.registerurl(%{})
      "Required Parameter missing, 'ConfirmationURL', 'ValidationURL','ResponseType'" = result
    end

    test "simulate/1 should send money successfully" do
      {:ok, result} =
        C2B.simulate(%{
          command_id: "CustomerPayBillOnline",
          phone_number: "254728833100",
          amount: 10,
          bill_reference: "Some Reference"
        })

      assert result["OriginatorCoversationID"] == "9769-145819182-2"
      assert result["ResponseDescription"] == "Accept the service request successfully."
    end

    test "validate/1 should error out without required parameter" do
      {:error, result} = C2B.simulate(%{})
      "Required Parameter missing, 'CommandID','Amount','Msisdn', 'BillRefNumber'" = result
    end
  end
end
