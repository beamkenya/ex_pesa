defmodule ExPesa.Mpesa.Reversal do
  @moduledoc """
  Reversal API enables reversal of transactions done
  You will be able to reverse a transaction where you are the credit party. This means it will be done via the Web portal, and may require manual authorization from the Service Provider side. But if you are allowed to reverse a transaction via API, it may also need to be authorized.

  An initiator requires the Org Reversals Initiator role to be able to perform reversals via API
  """
  import ExPesa.Mpesa.MpesaBase
  alias ExPesa.Util

  def reverse(params, option \\ :standalone)

  def reverse(%{transaction_id: _trans_id, amount: _amount} = params, :standalone) do
    config = Application.get_env(:ex_pesa, :mpesa)[:reversal]
    credential = Util.get_security_credential_for(:reversal)

    %{
      security_credential: credential,
      initiator: config[:initiator_name],
      receiver_party: config[:shortcode]
    }
    |> Map.merge(params)
    |> reversal_payload()
    |> request_reversal()
  end

  def reverse(%{transaction_id: _trans_id, amount: _amount} = params, api) do
    config = Application.get_env(:ex_pesa, :mpesa)[api]
    credential = Util.get_security_credential_for(api)

    %{
      security_credential: credential,
      initiator: config[:initiator_name],
      receiver_party: config[:shortcode]
    }
    |> Map.merge(params)
    |> reversal_payload()
    |> request_reversal()
  end

  defp reversal_payload(params) do
    %{
      "Initiator" => params.initiator,
      "SecurityCredential" => params.security_credential,
      "CommandID" => params.command_id,
      "TransactionID" => params.transaction_id,
      "Amount" => params.amount,
      "ReceiverParty" => params.receiver_party,
      "RecieverIdentifierType" => params.receiver_identifier,
      "ResultURL" => params.result_url,
      "QueueTimeOutURL" => params.queue_time_out_url,
      "Remarks" => params.remark,
      "Occasion" => params.work
    }
  end

  defp request_reversal(payload) do
    make_request("/mpesa/reversal/v1/request", payload)
  end
end
