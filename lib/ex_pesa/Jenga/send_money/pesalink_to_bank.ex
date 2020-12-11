defmodule ExPesa.Jenga.SendMoney.PesalinkToBank do
  @moduledoc """
  This enables your application to send money to a PesaLink participating bank.
  It is restricted to Kenya.
  """

  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @uri_affix "/transaction/v2/remittance#pesalinkacc"

  @doc """
  Send Money to other banks via Pesalink.
    - Resitricted to Kenya.
    - Recieving bank has to be a participant of Pesalink.

      Read more about Pesalink participating banks here: https://ipsl.co.ke/participating-banks/

  ## Parameters

  attrs: - a map containing:
    - `source` - a map containing; `countryCode`, `name` and `accountNumber`
    - `destination` - a map containing; `type`, `countryCode`, `name`, `mobileNumber`, `bankCode` and `accountNumber`
    - `transfer` - a map containing; `type`, `amount`, `currencyCode`, `reference`, `date` and `description`

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#pesalink2bank
  ## Example
      iex> ExPesa.Jenga.SendMoney.PesalinkToBank.request(%{ source: %{ countryCode: "KE", name: "John Doe", accountNumber: "1460163242696" }, destination: %{ type: "bank", countryCode: "KE", name: "Tom Doe", mobileNumber: "0722000000", bankCode: "01", accountNumber: "01100762802910" }, transfer: %{ type: "PesaLink", amount: "1000", currencyCode: "KES", reference: "639434645738", date: "2020-11-25", description: "some remarks here" } })
      {:ok,
        %{
          "transactionId" => "1452854",
          "status" => "SUCCESS",
          "description" => "Confirmed. Ksh 1000 Sent to 01100762802910 -Tom Doe from your account 1460163242696 on 20-05-2019 at 141313 Ref. 707700078800 Thank you"
        }}
  """
  @spec request(map()) :: {:error, any()} | {:ok, any()}
  def request(
        %{
          source: %{countryCode: _, name: _, accountNumber: accountNumber},
          destination: %{
            type: _,
            countryCode: _,
            name: name,
            bankCode: _,
            accountNumber: _
          },
          transfer: %{
            type: _,
            amount: amount,
            currencyCode: currencyCode,
            reference: reference,
            date: _,
            description: _
          }
        } = requestBody
      ) do
    message = "#{amount}#{currencyCode}#{reference}#{name}#{accountNumber}"
    headers = [{"signature", Signature.sign(message)}]

    make_request(@uri_affix, requestBody, headers)
  end

  def request(_) do
    {:error, "Required Parameters missing, check your request body"}
  end
end
