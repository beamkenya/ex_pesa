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
  - `PartyA` [Numeric] - Organization/MSISDN receiving the transaction, can be
    -Shortcode (6 digits)
    -MSISDN (12 Digits)
  - `IdentifierType` [Numeric] - Type of organization receiving the transaction can be the folowing:
      1 – MSISDN
      2 – Till Number
      4 – Organization short code
  - `Remarks`[String] - Comments that are sent along with the transaction, can be a sequence of characters up to 100
  - `Initiator` [Alpha-Numeric] - The name of Initiator to initiating  the request. This is the credential/username
  used to authenticate the transaction request
  - `SecurityCredential` [String] - Encrypted Credential of user getting transaction amount	String
  Encrypted password for the initiator to authenticate the transaction request
  - `QueueTimeOutURL` [URL] - The path that stores information of time out transaction. Takes the form of
  https://ip or domain:port/path
  - `ResultURL`[URL] - The path that stores information of transaction. Example https://ip or domain:port/path
  - `TransactionID` [Alpha-Numeric] - Unique identifier to identify a transaction on M-Pesa	Alpha-Numeric	LKXXXX1234
  -  `Occasion` [ String] -  Optional Parameter 	String	sequence of characters up to 100


  ## Parameters
  The following are the parameters required for this method, the rest are fetched from config
  files.
  - `occasion`:
  - `party_a`:
  - `identifier_type``
  - `remarks``
  - `transaction_id`
  Their details have been covered above in the documentation.

  ## Example

      iex> ExPesa.Mpesa.TransactionStatus.request(%{occasion: "Some Occasion",party_a: "600247",identifier_type: "4",remarks: "CustomerPayBillOnline",transaction_id: "SOME7803"})
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
    case get_security_credential_for(:b2b) do
      nil -> {:error, "cannot generate security_credential due to missing configuration fields"}
      security_credential -> query(security_credential, params)
    end
  end

  @doc false
  def request() do
    {:error,
     "Some Required Parameter missing, check whether you have 'occasion', 'party_a', 'identifier_type', 'remarks',  and 'transaction_id'"}
  end

  @spec request(map()) :: {:error, any()} | {:ok, any()}
  defp query(security_credential, %{
         occasion: occasion,
         transaction_id: transaction_id,
         party_a: party_a,
         identifier_type: identifier_type,
         remarks: remarks
       }) do
    payload = %{
      "CommandID" => "TransactionStatusQuery",
      "PartyA" => party_a,
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
end
