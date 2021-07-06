defmodule ExPesa.Mpesa.Stk do
  @moduledoc """
  Lipa na M-Pesa Online Payment API is used to initiate a M-Pesa transaction on behalf of a customer using STK Push. This is the same technique mySafaricom App uses whenever the app is used to make payments.
  """

  import ExPesa.Mpesa.MpesaBase
  import ExPesa.Util

  @doc """
  Initiates the Mpesa Lipa Online STK Push .

  ## Configuration

  Add below config to dev.exs / prod.exs files
  This asumes you have a clear understanding of how Daraja API works. See docs here https://developer.safaricom.co.ke/docs#lipa-na-m-pesa-online-payment

  `config.exs`
  ```elixir
    config :ex_pesa,
        mpesa: [
            consumer_key: "",
            consumer_secret: "",
            mpesa_short_code: "",
            mpesa_passkey: "",
            mpesa_callback_url: ""
        ]
  ```

  ## Parameters

  attrs: - a map containing:
  - `phone` - The MSISDN sending the funds(PhoneNumber).
  - `amount` - The amount to be transacted.
  - `reference` - Used with M-Pesa PayBills(AccountReference).
  - `description` - A description of the transaction(TransactionDesc).

  ## Example

      iex> ExPesa.Mpesa.Stk.request(%{amount: 10, phone: "254724540000", reference: "reference", description: "description"})
      {:ok,
        %{
        "CheckoutRequestID" => "ws_CO_010320202011179845",
        "CustomerMessage" => "Success. Request accepted for processing",
        "MerchantRequestID" => "25558-10595705-4",
        "ResponseCode" => "0",
        "ResponseDescription" => "Success. Request accepted for processing"
        }}
  """
  @spec request(map()) :: {:error, any()} | {:ok, any()}
  def request(%{
        amount: amount,
        phone: phone,
        reference: reference,
        description: description
      }) do
    paybill = Application.get_env(:ex_pesa, :mpesa)[:mpesa_short_code]
    passkey = Application.get_env(:ex_pesa, :mpesa)[:mpesa_passkey]
    {:ok, timestamp} = generate_timestamp()
    password = Base.encode64(paybill <> passkey <> timestamp)

    payload = %{
      "BusinessShortCode" => paybill,
      "Password" => password,
      "Timestamp" => timestamp,
      "TransactionType" => "CustomerPayBillOnline",
      "Amount" => amount,
      "PartyA" => phone,
      "PartyB" => paybill,
      "PhoneNumber" => phone,
      "CallBackURL" => Application.get_env(:ex_pesa, :mpesa)[:mpesa_callback_url],
      "AccountReference" => reference,
      "TransactionDesc" => description
    }

    make_request("/mpesa/stkpush/v1/processrequest", payload)
  end

  def request(_) do
    {:error, "Required Parameters missing, 'phone, 'amount', 'reference', 'description'"}
  end

  @doc """
  STK PUSH Transaction Validation

  ## Configuration

  Add below config to dev.exs / prod.exs files (at this stage after STK, the config keys should be there)
  This asumes you have a clear understanding of how Daraja API works. See docs here https://developer.safaricom.co.ke/docs#lipa-na-m-pesa-online-query-request

  `config.exs`
  ```elixir
    config :ex_pesa,
        mpesa: [
            consumer_key: "",
            consumer_secret: "",
            mpesa_short_code: "",
            mpesa_passkey: "",
        ]
  ```

  ## Parameters

  attrs: - a map containing:
  - `checkout_request_id` - Checkout RequestID.

  ## Example

      iex> ExPesa.Mpesa.Stk.validate(%{checkout_request_id: "ws_CO_260820202102496165"})
      {:ok,
        %{
          "CheckoutRequestID" => "ws_CO_260820202102496165",
          "MerchantRequestID" => "11130-78831728-4",
          "ResponseCode" => "0",
          "ResponseDescription" => "The service request has been accepted successsfully",
          "ResultCode" => "1032",
          "ResultDesc" => "Request cancelled by user"
        }
      }
  """
  @spec validate(map()) :: {:error, any()} | {:ok, any()}
  def validate(%{checkout_request_id: checkout_request_id}) do
    paybill = Application.get_env(:ex_pesa, :mpesa)[:mpesa_short_code]
    passkey = Application.get_env(:ex_pesa, :mpesa)[:mpesa_passkey]
    {:ok, timestamp} = generate_timestamp()
    password = Base.encode64(paybill <> passkey <> timestamp)

    payload = %{
      "BusinessShortCode" => paybill,
      "Password" => password,
      "Timestamp" => timestamp,
      "CheckoutRequestID" => checkout_request_id
    }

    make_request("/mpesa/stkpushquery/v1/query", payload)
  end

  def validate(_) do
    {:error, "Required Parameter missing, 'CheckoutRequestID'"}
  end
end
