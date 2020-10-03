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

  #### B2B - Configuration Parameters
  - `initiator` - This is the credential/username used to authenticate the transaction request.
    Environment
      - production -
        - create a user with api access method (access channel)
        - Enter user name
        - assign business manager role and B2B ORG API initiator role.
      Use the username from your notifitation channel (SMS)
      - sandbox - use your own custom username
  - `timeout_url' - The path that stores information of time out transactions.it should be properly validated to make sure that it contains the port, URI and domain name or publicly available IP.
  - `result_url` - The path that receives results from M-Pesa it should be properly validated to make sure that it contains the port, URI and domain name or publicly available IP.
  - `security credential` - To generate security_credential, head over to https://developer.safaricom.co.ke/test_credentials, then Initiator Security Password for your environment
    - Test - use the above test security credential
    - Production - use the actual production security credential

    `config.exs`
    ```elixir
      config :ex_pesa,
          mpesa: [
              b2b: [
                short_code: "",
                initiator_name: "",
                timeout_url: "",
                result_url: "",
                security_credential: "<credential here>"
              ]
          ]
    ```

  Alternatively, generate security credential using certificate
    `cert` - This is the M-Pesa public key certificate used to encrypt your plain password.
    There are 2 types of certificates.
      - sandox - https://developer.safaricom.co.ke/sites/default/files/cert/cert_sandbox/cert.cer
      - production - https://developer.safaricom.co.ke/sites/default/files/cert/cert_prod/cert.cer
    `password` - This is a plain unencrypted password.
    Environment
      - production - set password from the organization portal.
      - sandbox - use your own custom password

    `config.exs`
    ```elixir
      config :ex_pesa,
          mpesa: [
              cert: "<certificate content>"
              b2b: [
                short_code: "",
                initiator_name: "",
                password: "<your password>",
                timeout_url: "",
                result_url: ""
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

  def request(params) do
    case get_security_credential_for(:b2b) do
      nil -> {:error, "cannot generate security_credential due to missing configuration fields"}
      security_credential -> b2b_request(security_credential, params)
    end
  end

  def request() do
    {:error,
     "Required Parameter missing, 'command_id','amount','receiver_party', 'remarks','account_reference'"}
  end

  defp b2b_request(security_credential, %{
         command_id: command_id,
         amount: amount,
         receiver_party: receiver_party,
         remarks: remarks,
         account_reference: account_reference
       }) do
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
