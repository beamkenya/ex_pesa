defmodule ExPesa.Jenga.SendMoney.Swift do
  @moduledoc false
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @doc """
  Send Money To Other Banks Via SWIFT 

  ## Parameters

  attrs: - a map containing:
  - `source` - a map containing; `countryCode`, `name` and `accountNumber`
  - `destination` - a map containing; `type` with a value of "SWIFT", `countryCode`, `name`, `bankCode`, `branchCode`, and `accountNumber`
  - `transfer` - a map containing; `type`, `amount`, `currencyCode`, `reference`, `date` and `description`

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#swift

  ## Example

      iex> ExPesa.Jenga.SendMoney.Swift.request(%{source: %{countryCode: "KE", name: "John Doe", accountNumber: "0770194201783" }, destination: %{ type: "bank", countryCode: "TZ", name: "Kafedha Mwapesa", bankCode: "07", branchCode: "026", accountNumber: "7265810011" }, transfer: %{ type: "SWIFT", amount: 1000, currencyCode: "KES", reference: "692194625821", date: "2020-12-03", description: "some remarks"}})
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
            bankCode: bankCode,
            branchCode: _wN,
            accountNumber: destAccNo
          },
          transfer: %{
            amount: amount,
            currencyCode: _currencyCode,
            reference: reference,
            date: _date,
            description: _description
          }
        } = requestBody
      ) do
    message = "#{reference}#{srcAccNo}#{destAccNo}#{amount}#{bankCode}"

    make_request("/transaction/v2/remittance#swift", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_), do: {:error, "Required Parameters missing, check your request body"}
end
