defmodule ExPesa.Jenga.SendMoney.ToMobileWallets do
  @moduledoc """
  This enables your application to send money to telco :iphone: wallets across Kenya, Uganda, Tanzania & Rwanda.
  """

  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @doc """
  Send Money To Mobile Wallets

  ## Parameters

  attrs: - a map containing:
  - `source` - a map containing; `countryCode`, `name` and `accountNumber`
  - `destination` - a map containing; `type`, `countryCode`, `name`, `mobileNumber` and `walletName`
  - `transfer` - a map containing; `type`, `amount`, `currencyCode`, `reference`, `date` and `description`
  and second optional parameter(boolean): `true` - if sending Equitel Number else `false` or ignore when sending to Safaricom/Airtel

  Read More about the parameters' descriptions here: https://developer.jengaapi.io/reference#remittance

  ## Example

      iex> ExPesa.Jenga.SendMoney.ToMobileWallets.request(%{ source: %{ countryCode: "KE", name: "John Doe", accountNumber: "0770194201783" }, destination: %{ type: "mobile", countryCode: "KE", name: "Tom Doe", mobileNumber: "0722000000", walletName: "Mpesa" }, transfer: %{ type: "MobileWallet", amount: "1000", currencyCode: "KES", reference: "639434645738", date: "2020-11-25", description: "some remarks here" } })
      {:ok,
        %{
          "transactionId" => "1452854",
          "status" => "SUCCESS"
        }}
  """
  @spec request(map(), boolean()) :: {:error, any()} | {:ok, any()}
  def request(requestBody, toEquitel \\ false)

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
            mobileNumber: _mN,
            walletName: _wN
          },
          transfer: %{
            type: _t,
            amount: amount,
            currencyCode: currencyCode,
            reference: refence,
            date: _date,
            description: _description
          }
        } = requestBody,
        toEquitel
      ) do
    message =
      if toEquitel,
        do: "#{accountNumber}#{amount}#{currencyCode}#{refence}",
        else: "#{amount}#{currencyCode}#{refence}#{accountNumber}"

    make_request("/transaction/v2/remittance#sendmobile", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_, _toEquitel) do
    {:error, "Required Parameters missing, check your request body"}
  end
end
