defmodule ExPesa.Jenga.SendMoney.Swift do
  @moduledoc """
  Swift allows sending of money to cross border banks.

  ## Country Codes
  To lookup the country codes you will use in your application you can visit https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements

  ## Bank Codes (BIC and IBAN)
  To lookup the BIC and IBANs you will use in your application you can visit https://www.theswiftcodes.com/

  ## Currency Codes
  To lookup the ISO currency code (ISO 4217) you will use in your application you can visit https://en.wikipedia.org/wiki/ISO_4217
  """
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @doc """
  Send Money To Other Banks Via SWIFT 

  ## Parameters

  attrs: - a map containing:
  - `source` - a map containing; `countryCode`, `name` and `accountNumber`
  - `destination` - a map containing; `type` with a value of "SWIFT", `countryCode`, `name`, `bankCode`, `branchCode`, and `accountNumber`
  - `transfer` - a map containing; `type`, `amount`, `currencyCode`, `reference`, `date`, `description` and `chargeOption` which can be either `SELF` or `OTHER`

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#swift

  ## Example

      iex> ExPesa.Jenga.SendMoney.Swift.request(%{source: %{countryCode: "KE", name: "John Doe", accountNumber: "0011547896523" }, destination: %{type: "bank", countryCode: "JP", name: "Tom Doe", bankBic: "BOTKJPJTXXX", accountNumber: "12365489", addressline1: "Post Box 56" }, transfer: %{ type: "SWIFT", amount: "2.00", currencyCode: "USD", reference: "692194625798", date: "2020-12-06", description: "some remarks", chargeOption: "SELF"}})
      {:ok,
        %{
          "transactionId" => "1452854",
          "status" => "SUCCESS"
        }}
  """
  @spec request(map()) :: {:error, any()} | {:ok, any()}
  def request(
        %{
          source: %{
            countryCode: _countryCode,
            name: _name,
            accountNumber: srcAccNo
          },
          destination: %{
            type: _type,
            countryCode: _cc,
            name: _n,
            bankBic: _bankBic,
            accountNumber: destAccNo,
            addressline1: _address
          },
          transfer: %{
            amount: amount,
            currencyCode: _currencyCode,
            reference: reference,
            date: date,
            description: _description,
            chargeOption: _chargeOption
          }
        } = requestBody
      ) do
    message = "#{reference}#{date}#{srcAccNo}#{destAccNo}#{amount}"

    make_request("/transaction/v2/remittance#swift", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_), do: {:error, "Required Parameters missing, check your request body"}
end
