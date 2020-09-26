defmodule ExPesa.Mpesa.C2B do
  @moduledoc """
  C2B M-Pesa API enables Paybill and Buy Goods merchants to integrate to M-Pesa and receive real time payments notifications.
  """

  import ExPesa.Mpesa.MpesaBase

  @doc """
  There are two URLs required for RegisterURL API: Validation URL and Confirmation URL.
  For the two URLs, below are some pointers. This will also apply to the Callback URLs used on other APIs:
  - Use publicly available (Internet-accessible) IP addresses or domain names.
  - Do not use the words MPesa, M-Pesa, Safaricom or any of their variants in either upper or lower cases in your URLs, the system filters these URLs out and blocks them. Of course any Localhost URL will be refused.
  - Do not use public URL testers e.g. mockbin or requestbin especially on production, they are also blocked by the API.

  ## Parameters

  attrs: - a map containing:
  - `ShortCode` - This is your paybill number/till number, which you expect to receive payments notifications about.
  - `ResponseType` - [Cancelled/Completed] This is the default action value that determines what MPesa will do in the scenario that
  your endpoint is unreachable or is unable to respond on time. Only two values are allowed: Completed or Cancelled.
  Completed means MPesa will automatically complete your transaction, whereas Cancelled means
  MPesa will automatically cancel the transaction, in the event MPesa is unable to reach your Validation URL.
  - `ConfirmationURL` - [confirmation URL].
  - `ValidationURL` - [validation URL].

  ## Example

      iex> ExPesa.Mpesa.C2B.registerurl(%{ConfirmationURL: "https://58cb49b30213.ngrok.io/confirmation", ValidationURL: "https://58cb49b30213.ngrok.io/validation",  ResponseType: "Completed"})
      {:ok,
        %{
          "ConversationID" => "",
          "OriginatorCoversationID" => "",
          "ResponseDescription" => "success"
        }
      }
  """

  def registerurl(%{
        ConfirmationURL: confirmation_url,
        ValidationURL: validation_url,
        ResponseType: response_type
      }) do
    paybill = Application.get_env(:ex_pesa, :mpesa)[:c2b_short_code]

    payload = %{
      "ShortCode" => paybill,
      "ResponseType" => response_type,
      "ConfirmationURL" => confirmation_url,
      "ValidationURL" => validation_url
    }

    make_request("/mpesa/c2b/v1/registerurl", payload)
  end

  def registerurl(%{}) do
    {:error, "Required Parameter missing, 'ConfirmationURL', 'ValidationURL','ResponseType'"}
  end

  @doc """
  This API is used to make payment requests from Client to Business (C2B).
  ## Parameters

  attrs: - a map containing:
  - `CommandID` - This is a unique identifier of the transaction type: There are two types of these Identifiers:
    CustomerPayBillOnline: This is used for Pay Bills shortcodes.
    CustomerBuyGoodsOnline: This is used for Buy Goods shortcodes.
  - `Amount` - This is the amount being transacted. The parameter expected is a numeric value.
  - `Msisdn` - This is the phone number initiating the C2B transaction.
  - `BillRefNumber` - This is used on CustomerPayBillOnline option only.
    This is where a customer is expected to enter a unique bill identifier, e.g an Account Number.
  - `ShortCode` - This is the Short Code receiving the amount being transacted.
  You can use the sandbox provided test credentials down below to simulates a payment made from the client phone's STK/SIM Toolkit menu, and enables you to receive the payment requests in real time.
  ## Example

      iex> ExPesa.Mpesa.C2B.simulate(%{command_id: "CustomerPayBillOnline", phone_number: "254728833100", amount: 10, bill_reference: "Some Reference" })
      {:ok,
        %{
          "ConversationID" => "AG_20200921_00006e93a78f009f7025",
          "OriginatorCoversationID" => "9769-145819182-2",
          "ResponseDescription" => "Accept the service request successfully."
        }
      }
  """

  def simulate(%{
        command_id: command_id,
        phone_number: phone_number,
        amount: amount,
        bill_reference: bill_reference
      }) do
    paybill = Application.get_env(:ex_pesa, :mpesa)[:c2b_short_code]

    payload = %{
      "ShortCode" => paybill,
      "CommandID" => command_id,
      "Amount" => amount,
      "Msisdn" => phone_number,
      "BillRefNumber" => bill_reference
    }

    make_request("/mpesa/c2b/v1/simulate", payload)
  end

  def simulate(%{}) do
    {:error, "Required Parameter missing, 'CommandID','Amount','Msisdn', 'BillRefNumber'"}
  end
end
