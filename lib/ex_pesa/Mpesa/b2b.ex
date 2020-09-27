defmodule ExPesa.Mpesa.B2B do
  @moduledoc """
  This API enables Business to Business (B2B) transactions between a business and another business.
  Use of this API requires a valid and verified B2B M-Pesa short code for the business initiating the transaction and the both businesses involved in the transaction.
  """
  import ExPesa.Mpesa.MpesaBase
  import ExPesa.Util

  @doc """
  This API enables Business to Business (B2B) transactions between a business and another business. Use of this API requires a valid and verified B2B M-Pesa short code for the business initiating the transaction and the both businesses involved in the transaction.

  ## Configuration

  Add below config to dev.exs / prod.exs files
  This asumes you have a clear understanding of how Daraja API works. See docs here https://developer.safaricom.co.ke/docs#b2b-api

  `config.exs`
  ```elixir
    config :ex_pesa,
        mpesa: [
            b2b: [
              short_code: "",
              initiator_name: "",
              password: "",
              timeout_url: "",
              result_url: "",
              security_credential: ""
            ]
        ]
  ```

  ## Parameters

  attrs: - a map containing:
  - `command_id` - Unique command for each transaction type, possible values are: BusinessPayBill, MerchantToMerchantTransfer, MerchantTransferFromMerchantToWorking, MerchantServicesMMFAccountTransfer, AgencyFloatAdvance
  - `amount` - The amount being transacted.
  - `receiver_party` - Organization’s short code receiving the funds being transacted
  - `remarks` - Comments that are sent along with the transaction.
  - `account_reference` - Account Reference mandatory for “BusinessPaybill” CommandID.

  ## Example

      iex> ExPesa.Mpesa.B2B.request(%{command_id: "BusinessPayBill", amount: 10500, receiver_party: 600000, remarks: "B2B Request", account_reference: "BILL PAYMENT"})
      {:ok,
        %{
          "ConversationID" => "AG_20200927_00007d4c98884c889b25",
          "OriginatorConversationID" => "27274-37744848-4",
          "ResponseCode" => "0",
          "ResponseDescription" => "Accept the service request successfully."
        }}
  """

  def request(%{
        command_id: command_id,
        amount: amount,
        receiver_party: receiver_party,
        remarks: remarks,
        account_reference: account_reference
      }) do
    security_credential =
      case Application.get_env(:ex_pesa, :mpesa)[:b2b][:security_credential] do
        nil ->
          password = Application.get_env(:ex_pesa, :mpesa)[:b2b][:password]
          get_security_credential(%{Password: password})

        credential ->
          credential
      end

    payload = %{
      "Initiator" => Application.get_env(:ex_pesa, :mpesa)[:b2b][:initiator_name],
      "SecurityCredential" => security_credential,
      "CommandID" => command_id,
      "Amount" => amount,
      "PartyA" => Application.get_env(:ex_pesa, :mpesa)[:b2b][:short_code],
      "SenderIdentifierType" => 4,
      "PartyB" => receiver_party,
      "RecieverIdentifierType" => 4,
      "Remarks" => remarks,
      "AccountReference" => account_reference,
      "QueueTimeOutURL" => Application.get_env(:ex_pesa, :mpesa)[:b2b][:timeout_url],
      "ResultURL" => Application.get_env(:ex_pesa, :mpesa)[:b2b][:result_url]
    }

    make_request("/mpesa/b2b/v1/paymentrequest", payload)
  end
end
