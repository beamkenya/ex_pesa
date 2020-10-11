defmodule ExPesa.Mpesa.Reversal do
  @moduledoc """
  Reversal API enables reversal of transactions done
  You will be able to reverse a transaction where you are the credit party. This means it will be done via the Web portal, and may require manual authorization from the Service Provider side. But if you are allowed to reverse a transaction via API, it may also need to be authorized.

  An initiator requires the Org Reversals Initiator role to be able to perform reversals via API
  """
  import ExPesa.Mpesa.MpesaBase
  alias ExPesa.Util

  @doc """
  Makes a request to the mpesa reversal endpoint with the given params.

  ## Params
  The function requires two keys to be present for a successful request, `:transation_id` and `:amount`
  The params can be any of the accepted params by the api endpoint with the keys converted to snake case. For example
  `QueueTimeOutURL` is expected to be in the format `queue_time_out_url`.

  Additionally, the keys `:security_credential, :initiator, :receiver_party, :result_url, :queue_time_out_url` are
  loaded from the respective config and used if they're not provided as part of the params in the arguments.

  ## Options
  Because reversal can be done for B2B, B2C or C2B, this function allows for an option to load the configs from.
  It defaults to `:standalone` which means the config to use will be the `:reversal` under the `:mpesa` config.
  In order to reuse the configs for the other apis, use the parent key under the mpesa config. 
  For example, in order to use the `b2b` configs, pass in `:b2b` as the option
  """
  def reverse(params, option \\ :standalone)

  def reverse(%{transaction_id: _trans_id, amount: _amount} = params, :standalone) do
    config = Application.get_env(:ex_pesa, :mpesa)[:reversal]
    credential = Util.get_security_credential_for(:reversal)

    %{
      security_credential: credential,
      initiator: config[:initiator_name],
      receiver_party: config[:shortcode],
      result_url: config[:result_url],
      queue_time_out_url: config[:result_url]
    }
    |> Map.merge(params)
    |> reversal_payload()
    |> request_reversal()
  end

  def reverse(%{transaction_id: _trans_id, amount: _amount} = params, api) do
    config = Application.get_env(:ex_pesa, :mpesa)[api]
    credential = Util.get_security_credential_for(api)
    reversal_config = Application.get_env(:ex_pesa, :mpesa)[:reversal]

    %{
      security_credential: credential,
      initiator: config[:initiator_name],
      receiver_party: config[:shortcode],
      result_url: reversal_config[:result_url],
      queue_time_out_url: reversal_config[:timeout_url]
    }
    |> Map.merge(params)
    |> reversal_payload()
    |> request_reversal()
  end

  def reverse(_, _) do
    {:error, "either transaction_id or amount is missing from the given params"}
  end

  defp reversal_payload(params) do
    %{
      "Initiator" => params.initiator,
      "SecurityCredential" => params.security_credential,
      "CommandID" => "TransactionReversal",
      "TransactionID" => params.transaction_id,
      "Amount" => params.amount,
      "ReceiverParty" => params.receiver_party,
      "RecieverIdentifierType" => "4",
      "ResultURL" => params.result_url,
      "QueueTimeOutURL" => params.queue_time_out_url,
      "Remarks" => params[:remarks] || "Payment Reversal",
      "Occasion" => params[:occasion] || "Payment Reversal"
    }
  end

  defp request_reversal(payload) do
    make_request("/mpesa/reversal/v1/request", payload)
  end
end
