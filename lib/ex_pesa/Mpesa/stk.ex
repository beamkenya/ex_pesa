defmodule ExPesa.Mpesa.Stk do
  @moduledoc false

  import ExPesa.Mpesa.MpesaBase

  def request(%{
        amount: amount,
        phone: phone,
        reference: reference,
        description: description
      }) do
    
    paybill = Application.get_env(:ex_pesa, :mpesa)[:mpesa_short_code]
    passkey = Application.get_env(:ex_pesa, :mpesa)[:mpesa_passkey]
    {:ok, timestamp} = Timex.now() |> Timex.format("%Y%m%d%H%M%S", :strftime)
    password = Base.encode64(paybill <> passkey <> timestamp)

    payload = %{
      "BusinessShortCode" => paybill,
      "Password" => password,
      "Timestamp" => timestamp,
      "TransactionType" => "CustomerPayBillOnline",
      "Amount" => amount,
      "PartyA" => phone,
      "PartyB" => paybill,
      "PhoneNumber" => phone,
      "CallBackURL" => Application.get_env(:ex_pesa, :mpesa)[:mpesa_callback_url],
      "AccountReference" => reference,
      "TransactionDesc" => description
    }

    make_request("/mpesa/stkpush/v1/processrequest", payload)
  end
end
