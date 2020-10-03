defmodule ExPesa.Mpesa.TransactionStatus do
  @moduledoc """
  Use this api to check the transaction status.
  """

  import ExPesa.Mpesa.MpesaBase

  @doc """
  Initiates the Mpesa Lipa Online STK Push .

  ExPesa.Mpesa.TransactionStatus.query(%{command_id: "Command ID - TransactionStatusQuery",
        identifier_type:  identifier_type,
        remarks: "Some Remarks",
        initiator: "kamalogudah",
        security_credential: security_credential,
        queue_timeout_url: queue_timeout_url,
        result_url: result_url,
        transaction_id: transaction_id,
        occasion: "Some Occasion"})

"TransactionID":"Transaction ID e.g LC7918MI73" ,
"PartyA":"Phone number that initiated the transaction" ,
"IdentifierType":"1" ,
"ResultURL":"https://ip_address:port/result_url" ,
"QueueTimeOutURL":"https://ip_address:port/timeout_url" ,
"Remarks":"Remarks" ,
"Occasion": "Optional parameter"

  """
  @spec request(map()) :: {:error, any()} | {:ok, any()}
  def query(%{
        command_id: command_id,
        remarks: remarks,
        initiator: initiator,
        security_credential: security_credential,
        queue_timeout_url: queue_timeout_url,
        result_url: result_url,
        transaction_id: transaction_id,
        occasion: occasion

      }) do
    paybill = Application.get_env(:ex_pesa, :mpesa)[:mpesa_short_code]
    passkey = Application.get_env(:ex_pesa, :mpesa)[:mpesa_passkey]
    {:ok, timestamp} = Timex.now() |> Timex.format("%Y%m%d%H%M%S", :strftime)
    password = Base.encode64(paybill <> passkey <> timestamp)
    security_credential = Base.encode64(password)

    payload = %{
      "CommandID" => command_id,
      "ShortCode" =>  paybill,
      "IdentifierType" => "1",
      "Remarks" => "CustomerPayBillOnline",
      "SecurityCredential" => security_credential,
      "Initiator" => amount,
      "SecurityCredential" => phone,
      "QueueTimeOutURL" => paybill,
      "ResultURL" => phone,
      "TransactionID" => Application.get_env(:ex_pesa, :mpesa)[:mpesa_callback_url],
      "Occasion" => occasion
    }

    make_request("/mpesa/transactionstatus/v1/query", payload)
  end

  def query(_) do
    {:error, "Required Parameters missing, 'CommandID, 'IdentifierType', 'Remarks', 'Initiator'"}
  end

end
