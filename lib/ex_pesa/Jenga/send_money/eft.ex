defmodule ExPesa.Jenga.SendMoney.EFT do
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

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
