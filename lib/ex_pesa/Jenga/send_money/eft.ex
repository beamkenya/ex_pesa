defmodule ExPesa.Jenga.SendMoney.EFT do
  @moduledoc """
  This module enables you to Send Money To Other Banks Via Electronic Funds Transfer (EFT)
  """
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @doc """
  Send Money To Other Banks Via Electronic Funds Transfer (EFT)

  ## Parameters

  attrs: - a map containing:
  - `source` - a map containing; `countryCode`, `name` and `accountNumber`
  - `destination` - a map containing; `type`, `countryCode`, `name`, `bankCode`, `branchCode`, and `accountNumber`
  - `transfer` - a map containing; `type`, `amount`, `currencyCode`, `reference`, `date` and `description`

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#eft

  ## Example

      iex> ExPesa.Jenga.SendMoney.EFT.request(%{ source: %{ countryCode: "KE", name: "Jhn Doe", accountNumber: "0770194201783" }, destination: %{ type: "bank", countryCode: "KE", name: "John Doe", bankCode: "07", branchCode: "026", accountNumber: "7265810011" }, transfer: %{ type: "EFT", amount: 1000, currencyCode: "KES", reference: "692194625821", date: "2020-12-03", description: "some remarks here" } })
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
            bankCode: bankCode,
            branchCode: _wN,
            accountNumber: accNo
          },
          transfer: %{
            type: _t,
            amount: amount,
            currencyCode: _currencyCode,
            reference: reference,
            date: _date,
            description: _description
          }
        } = requestBody
      ) do
    message = "#{reference}#{accountNumber}#{accNo}#{amount}#{bankCode}"

    make_request("/transaction/v2/remittance#eft", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_), do: {:error, "Required Parameters missing, check your request body"}
end
