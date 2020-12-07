defmodule ExPesa.Jenga.SendMoney.PesalinkToMobile do
  @moduledoc """
  This module enables you to Send Money To Other People's mobile phone through PesaLink
  """
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @doc """
  Send Money To Other People's mobile phone through PesaLink

  ## Parameters

  attrs: - a map containing:
  - `source` - a map containing; `countryCode[string]`, `name[string]` and `accountNumber[string]`
  - `destination` - a map containing; `type[string]`, `countryCode[string]`, `name[string]`, `bankCode[string]`, `mobileNumber[string]`
  - `transfer` - a map containing; `type[string]`, `amount[string]`, `currencyCode[string]`, `reference[string]`, `date[string]` and `description[string]`

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#pesalink2mobile

  ## Example

      iex> ExPesa.Jenga.SendMoney.PesalinkToMobile.request(%{ source: %{ countryCode: "KE", name: "John Doe", accountNumber: "0770194201783" }, destination: %{ type: "bank", countryCode: "KE", name: "John Doe", bankCode: "07", mobileNumber: "0722000000" }, transfer: %{ type: "PesaLink", amount: "1000", currencyCode: "KES", reference: "692194625821", date: "2020-12-03", description: "some remarks here" } })
      {:ok,
        %{
          "transactionId" => "10000345333355",
          "status" => "SUCCESS"
        }
      }
  """
  @spec request(map()) :: {:error, any()} | {:ok, any()}
  def request(
        %{
          source: %{
            countryCode: countryCode,
            name: _senderName,
            accountNumber: accountNumber
          },
          destination: %{
            type: _destType,
            countryCode: countryCode,
            name: recipientName,
            bankCode: _bankCode,
            mobileNumber: _mobileNumber
          },
          transfer: %{
            type: "PesaLink",
            amount: amount,
            currencyCode: currencyCode,
            reference: reference,
            date: _date,
            description: _description
          }
        } = requestBody
      ) do
    message = "#{amount}#{currencyCode}#{reference}#{recipientName}#{accountNumber}"

    make_request("/transaction/v2/remittance#pesalinkmobile", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_), do: {:error, "Required Parameters missing, check your request body"}
end
