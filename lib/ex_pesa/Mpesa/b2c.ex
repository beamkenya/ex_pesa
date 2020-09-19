defmodule ExPesa.Mpesa.B2c do
  @moduledoc """
    Business to Customer (B2C) API enables the Business or organization to pay its customers who are the end-users of its products or services. 
    Currently, the B2C API allows the org to perform around 3 types of transactions: Salary Payments, Business Payments or Promotion payments. 
    Salary payments are used by organizations paying their employees via M-Pesa, Business Payments are normal business transactions to customers 
    e.g. bank transfers to mobile, Promotion payments are payments made by organization carrying out promotional services e.g.
     betting companies paying out winnings to clients
  """

  import ExPesa.Mpesa.MpesaBase

  @doc """
  Initiates a B2C mpesa request.


  """

  def initiate_request(%{
        username: username,
        command_id: command_id,
        amount: amount,
        phone_number: phone_number,
        remarks: remarks,
        occassion: occassion
      }) do
    short_code = Application.get_env(:ex_pesa, :mpesa)[:mpesa_short_code]
    passkey = Application.get_env(:ex_pesa, :mpesa)[:mpesa_passkey]
    {:ok, timestamp} = Timex.now() |> Timex.format("%Y%m%d%H%M%S", :strftime)
    credential = Base.encode64(short_code <> passkey <> timestamp)

    payload = %{
      "InitiatorName" => username,
      "SecurityCredential" => credential,
      "CommandID" => command_id,
      "Amount" => amount,
      "PartyA" => short_code,
      "PartyB" => phone_number,
      "Remarks" => remarks,
      "QueueTimeOutURL" => Application.get_env(:ex_pesa, :mpesa)[:mpesa_callback_url],
      "ResultURL" => Application.get_env(:ex_pesa, :mpesa)[:mpesa_callback_url],
      "Occassion" => occassion
    }

    make_request("/mpesa/b2c/v1/paymentrequest", payload)
  end
end
