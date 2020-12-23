defmodule ExPesa.Jenga.SendMoney.RTGS do
  @moduledoc """
  The Real Time Gross Settlement (RTGS) web-service.
  This module enables an application to send money intra-country to other bank accounts.
  """
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @doc """
  Send money intra-country to other bank accounts (RTGS)

  ## Parameters

  attrs: - a map containing:
  - `source` - a map containing; `countryCode`, `name` and `accountNumber`
  - `destination` - a map containing; `type`, `countryCode`, `name`, `bankCode` and `accountNumber`
  - `transfer` - a map containing; `type`, `amount`, `currencyCode`, `reference`, `date` and `description`

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#rfgs

  ## Example

      iex> ExPesa.Jenga.SendMoney.RTGS.request(%{ source: %{ countryCode: "KE", name: "John Doe", accountNumber: "0011547896523" }, destination: %{ type: "bank", countryCode: "KE", name: "Tom Doe", bankCode: "70", accountNumber: "12365489" }, transfer: %{ type: "RTGS", amount: 4.00, currencyCode: "KES", reference: "692194625798", date: "2020-12-11", description: "some remarks here" } })
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
            accountNumber: accountNumber
          },
          destination: %{
            type: _type,
            countryCode: _cc,
            name: _n,
            bankCode: _bankCode,
            accountNumber: accNo
          },
          transfer: %{
            type: _t,
            amount: amount,
            currencyCode: _currencyCode,
            reference: reference,
            date: date,
            description: _description
          }
        } = requestBody
      ) do
    message = "#{reference}#{date}#{accountNumber}#{accNo}#{amount}"

    make_request("/transaction/v2/remittance#rtgs", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_), do: {:error, "Required Parameters missing, check your request body"}
end
