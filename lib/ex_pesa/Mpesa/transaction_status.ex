defmodule ExPesa.Mpesa.TransactionStatus do
  @moduledoc """
  Use this api to check the transaction status.
  """

  import ExPesa.Mpesa.MpesaBase
  import ExPesa.Util

  @doc """
  Transaction Status Query
  ## Requirement Params
  - `CommandID`[String] - Takes only 'TransactionStatusQuery' command id
  - `timeout_url` [URL] - The path that stores information of time out transaction. Takes the form of
  https://ip or domain:port/path
  - `result_url`[URL] - The path that stores information of transaction. Example https://ip or domain:port/path
  - `Initiator` [Alpha-Numeric] - The name of Initiator to initiating  the request. This is the credential/username
  used to authenticate the transaction request

   - `security credential` - To generate security_credential, head over to https://developer.safaricom.co.ke/test_credentials, then Initiator Security Password for your environment.

    `config.exs`
    ```elixir
      config :ex_pesa,
          mpesa: [
              cert: "",
              transaction_status: [
                initiator_name: "",
                password: "",
                timeout_url: "",
                result_url: "",
                security_credential: ""
              ]
          ]
    ```

  Alternatively, generate security credential using certificate
    `cert` - This is the M-Pesa public key certificate used to encrypt your plain password.
    There are 2 types of certificates.
      - sandox - https://developer.safaricom.co.ke/sites/default/files/cert/cert_sandbox/cert.cer .
      - production - https://developer.safaricom.co.ke/sites/default/files/cert/cert_prod/cert.cer .
    `password` - This is a plain unencrypted password.
    Environment
      - production - set password from the organization portal.
      - sandbox - use your own custom password

  ## Parameters
  The following are the parameters required for this method, the rest are fetched from config
  files.

  - `transaction_id` [Alpha-Numeric] - Unique identifier to identify a transaction on M-Pesa	Alpha-Numeric	LKXXXX1234
   - `receiver_party` [Numeric] - Organization/MSISDN receiving the transaction, can be
    -Shortcode (6 digits)
    -MSISDN (12 Digits)
  - `identifier_type` [Numeric] - Type of organization receiving the transaction can be the folowing:
      1 – MSISDN
      2 – Till Number
      4 – Organization short code
  - `remarks`[String] - Comments that are sent along with the transaction, can be a sequence of characters up to 100
  -  `occasion` [ String] -  Optional Parameter 	String	sequence of characters up to 100

  ## Example

      iex> ExPesa.Mpesa.TransactionStatus.request(%{transaction_id: "SOME7803", receiver_party: "600247", identifier_type: 4, remarks: "TransactionReversal",  occasion: "TransactionReversal"})
      {:ok,
        %{
            "ConversationID" => "AG_20201010_000056be35a7b266b43e",
            "OriginatorConversationID" => "27288-72545279-2",
            "ResponseCode" => "0",
            "ResponseDescription" => "Accept the service request successfully."
        }
      }

  """
  def request(params) do
    case get_security_credential_for(:transaction_status) do
      nil -> {:error, "cannot generate security_credential due to missing configuration fields"}
      security_credential -> query(security_credential, params)
    end
  end

  defp query(
         security_credential,
         %{
           transaction_id: transaction_id,
           receiver_party: receiver_party,
           identifier_type: identifier_type,
           remarks: remarks
         } = params
       ) do
    occasion = Map.get(params, :occasion, nil)

    payload = %{
      "CommandID" => "TransactionStatusQuery",
      "PartyA" => receiver_party,
      "IdentifierType" => identifier_type,
      "Remarks" => remarks,
      "SecurityCredential" => security_credential,
      "Initiator" => Application.get_env(:ex_pesa, :mpesa)[:transaction_status][:initiator_name],
      "QueueTimeOutURL" =>
        Application.get_env(:ex_pesa, :mpesa)[:transaction_status][:timeout_url],
      "ResultURL" => Application.get_env(:ex_pesa, :mpesa)[:transaction_status][:result_url],
      "TransactionID" => transaction_id,
      "Occasion" => occasion
    }

    make_request("/mpesa/transactionstatus/v1/query", payload)
  end

  defp query(_security_credential, _) do
    {:error,
     "Some Required Parameter missing, check whether you have 'transaction_id', 'receiver_party', 'identifier_type', 'remarks'"}
  end
end
