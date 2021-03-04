defmodule ExPesa.Mpesa.B2c do
  @moduledoc """
    Business to Customer (B2C) API enables the Business or organization to pay its customers who are the end-users of its products or services.
    Currently, the B2C API allows the org to perform around 3 types of transactions: SalaryPayments, BusinessPayments or Promotion payments.
    Salary payments are used by organizations paying their employees via M-Pesa, Business Payments are normal business transactions to customers
    e.g. bank transfers to mobile, Promotion payments are payments made by organization carrying out promotional services e.g.
     betting companies paying out winnings to clients
  """

  import ExPesa.Mpesa.MpesaBase
  import ExPesa.Util

  @doc """
  Initiates the Mpesa B2C .

  ## Configuration
  Add below config to dev.exs / prod.exs files

  `config.exs`
  ```elixir
    config :ex_pesa,
        mpesa: [
            cert: "",
            b2c: [
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
    - `command_id` - Unique command for each transaction type, possible values are: BusinessPayBill, MerchantToMerchantTransfer, MerchantTransferFromMerchantToWorking, MerchantServicesMMFAccountTransfer, AgencyFloatAdvance.
    - `amount` - The amount being transacted.
    - `phone_number` - Phone number receiving the transaction.
    - `remarks` - Comments that are sent along with the transaction.
    - `occassion` - Optional.
    - `result_url` - The end-point that receives the response of the transaction. You can customize the result url. 
                      Defaults to the value passed in the config if not added to params

  ## Example
      iex> ExPesa.Mpesa.B2c.request(%{command_id: "BusinessPayment", amount: 10500, phone_number: "254722000000", remarks: "B2C Request", result_url: "https://58cb49b30213.ngrok.io/b2c/result_url"})
      {:ok,
        %{
          "ConversationID" => "AG_20201010_00006bd489ffcaf79e91",
          "OriginatorConversationID" => "27293-71728391-3",
          "ResponseCode" => "0",
          "ResponseDescription" => "Accept the service request successfully."
        }}
  """

  def request(params) do
    case get_security_credential_for(:b2c) do
      nil -> {:error, "cannot generate security_credential due to missing configuration fields"}
      security_credential -> b2c_request(security_credential, params)
    end
  end

  defp b2c_request(
         security_credential,
         %{
           command_id: command_id,
           amount: amount,
           phone_number: phone_number,
           remarks: remarks
         } = params
       ) do
    occassion = Map.get(params, :occassion)

    result_url =
      Map.get(params, :result_url, Application.get_env(:ex_pesa, :mpesa)[:b2c][:result_url])

    payload = %{
      "InitiatorName" => Application.get_env(:ex_pesa, :mpesa)[:b2c][:initiator_name],
      "SecurityCredential" => security_credential,
      "CommandID" => command_id,
      "Amount" => amount,
      "PartyA" => Application.get_env(:ex_pesa, :mpesa)[:b2c][:short_code],
      "PartyB" => phone_number,
      "Remarks" => remarks,
      "QueueTimeOutURL" => Application.get_env(:ex_pesa, :mpesa)[:b2c][:timeout_url],
      "ResultURL" => result_url,
      "Occassion" => occassion
    }

    make_request("/mpesa/b2c/v1/paymentrequest", payload)
  end

  defp b2c_request(_security_credential, _) do
    {:error, "Required Parameter missing, 'command_id','amount','phone_number', 'remarks'"}
  end
end
