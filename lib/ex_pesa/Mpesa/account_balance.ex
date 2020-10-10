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
                short_code: "",
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

  ## Example

      iex> ExPesa.Mpesa.AccountBalance.request()
      {:ok,
        %{
            "ConversationID" => "AG_20201010_00007d6021022d396df6",
            "OriginatorConversationID" => "28290-142922216-2",
            "ResponseCode" => "0",
            "ResponseDescription" => "Accept the service request successfully."
        }}
  """

  def request() do
    case get_security_credential_for(:balance) do
      nil -> {:error, "cannot generate security_credential due to missing configuration fields"}
      security_credential -> account_balance(security_credential)
    end
  end

  def account_balance(security_credential) do
    payload = %{
      "Initiator" => Application.get_env(:ex_pesa, :mpesa)[:balance][:initiator_name],
      "SecurityCredential" => security_credential,
      "CommandID" => "AccountBalance",
      "PartyA" => Application.get_env(:ex_pesa, :mpesa)[:balance][:short_code],
      "IdentifierType" => 4,
      "Remarks" => "Checking account balance",
      "QueueTimeOutURL" => Application.get_env(:ex_pesa, :mpesa)[:balance][:timeout_url],
      "ResultURL" => Application.get_env(:ex_pesa, :mpesa)[:balance][:result_url]
    }

    make_request("/mpesa/accountbalance/v1/query", payload)
  end
end
