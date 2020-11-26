defmodule ExPesa.Jenga.SendMoney.WithinEquityBank do
  @moduledoc """
  Move Funds Within Equity Bank :bank: Across Kenya, Uganda, Tanzania, Rwanda & South Sudan.
  """

  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @doc """
  Send Money Within Equity Bank

  ## Parameters

  attrs: - a map containing:
  - `source` - a map containing; `countryCode`, `name` and `accountNumber`
  - `destination` - a map containing; `type`, `countryCode`, `name` and `accountNumber`
  - `transfer` - a map containing; `type`, `amount`, `currencyCode`, `reference`, `date` and `description`

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#within-equity-bank

  ## Example

      iex> ExPesa.Jenga.SendMoney.WithinEquityBank.request(%{ source: %{ countryCode: "KE", name: "Jhn Doe", accountNumber: "0770194201783" }, destination: %{ type: "bank", countryCode: "KE", name: "John Doe", accountNumber: "0740161904311" }, transfer: %{ type: "InternalFundsTransfer", amount: 1000, currencyCode: "KES", reference: "692194625838", date: "2020-11-25", description: "some remarks here" } })
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
            accountNumber: _aN
          },
          transfer: %{
            type: _t,
            amount: amount,
            currencyCode: currencyCode,
            reference: refence,
            date: _date,
            description: _description
          }
        } = requestBody
      ) do
    message = "#{accountNumber}#{amount}#{currencyCode}#{refence}"

    make_request("/transaction/v2/remittance#sendeqtybank", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_) do
    {:error, "Required Parameters missing, check your request body"}
  end
end
