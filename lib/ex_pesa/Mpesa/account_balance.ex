defmodule ExPesa.Mpesa.AccountBalance do
  @moduledoc """
    The Account Balance API requests for the account balance of a shortcode.
  """
  import ExPesa.Mpesa.MpesaBase
  import ExPesa.Util

  @doc """
  Initiates account balnce request

  ## Configuration

  Add below config to dev.exs / prod.exs files
  This asumes you have a clear understanding of how Daraja API works. See docs here https://developer.safaricom.co.ke/docs#account-balance-api

  `config.exs`
  ```elixir
    config :ex_pesa,
        mpesa: [
            cert: "",
            balance: [
                initiator_name: "Safaricom1",
                password: "Safaricom133",
                timeout_url: "",
                result_url: "",
                security_credential: ""
            ]
        ]
  ```
  To generate security_credential, head over to https://developer.safaricom.co.ke/test_credentials, then Initiator Security Password for your environment.
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

  attrs: - a map containing:
  - `command_id` - A unique command passed to the M-Pesa system..
  - `short_code` - The shortcode of the organisation receiving the transaction.
  - `remarks` - Comments that are sent along with the transaction.
  - `account_type` - Organisation receiving the funds.

  ## Example

      iex> ExPesa.Mpesa.AccountBalance.request(%{command_id: "AccountBalance", short_code: "602843", remarks: "remarks", account_type: "Customer"})
      {:ok,
        %{
            "ConversationID" => "AG_20201010_00007d6021022d396df6",
            "OriginatorConversationID" => "28290-142922216-2",
            "ResponseCode" => "0",
            "ResponseDescription" => "Accept the service request successfully."
        }}
  """
  @spec request(map()) :: {:error, any()} | {:ok, any()}
  def request(params) do
    case get_security_credential_for(:balance) do
      nil -> {:error, "cannot generate security_credential due to missing configuration fields"}
      security_credential -> account_balance(security_credential, params)
    end
  end

  @doc false
  def request() do
    {:error,
     "Required Parameter missing, 'command_id','short_code', 'remarks','account_reference'"}
  end

  def account_balance(security_credential, %{
        command_id: command_id,
        short_code: short_code,
        remarks: remarks,
        account_type: account_type
      }) do
    payload = %{
      "Initiator" => Application.get_env(:ex_pesa, :mpesa)[:balance][:initiator_name],
      "SecurityCredential" => security_credential,
      "CommandID" => command_id,
      "PartyA" => short_code,
      "IdentifierType" => 4,
      "Remarks" => remarks,
      "AccountType" => account_type,
      "QueueTimeOutURL" => Application.get_env(:ex_pesa, :mpesa)[:balance][:timeout_url],
      "ResultURL" => Application.get_env(:ex_pesa, :mpesa)[:balance][:result_url]
    }

    make_request("/mpesa/accountbalance/v1/query", payload)
  end
end
