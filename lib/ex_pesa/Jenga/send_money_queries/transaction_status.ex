defmodule ExPesa.Jenga.SendMoneyQueries.TransactionStatus do
  @moduledoc """
  Use this API to check the status of a B2C transaction
  """

  import ExPesa.Jenga.JengaBase

  @doc """
  Check the status of a B2C transaction

  ## Parameters

  attrs: - a map containing:
  - `requestId` - a string
  - `destination` - a map containing; `type`
  - `transfer` - a map containing; `date`

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#query-status-b2c-transactions

  ## Example

      iex> ExPesa.Jenga.SendMoneyQueries.TransactionStatus.request(%{ requestId: "192108062104", destination: %{ type: "Mpesa" }, transfer: %{  date: "2020-12-17" } })
      {:ok,
        %{
          "transactionId" => "1452854",
          "status" => "SUCCESS"
        }}
  """

  @spec request(map()) :: {:error, any()} | {:ok, any()}
  def request(
        %{
          requestId: _ri,
          destination: %{
            type: _type
          },
          transfer: %{
            date: _date
          }
        } = requestBody
      ) do
    make_request("/transaction/v2/b2c/status/query", requestBody)
  end

  def request(_) do
    {:error, "Required Parameters missing, check your request body"}
  end
end
