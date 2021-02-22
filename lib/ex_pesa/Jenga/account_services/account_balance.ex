defmodule ExPesa.Jenga.AccountServices.AccountBalance do
  @moduledoc """
  This enables your application to retrieve the current and available balance of an account.
  """

  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @uri_affix "/account/v2/accounts/balances/"

  @doc """
  Inquire current and available account balance.
    - Currently restricted to banks in East and Central Africa ie
      Kenya, Uganda, Tanzania, Rwanda, Democratic Republic of Congo, South Sudan and Ethiopia.

    - This serves as the allowed country codes for quering account balances.
      Country code format information found here: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements

  ## Parameters

  attrs: - a map containing
    - `countryCode` - a string per above description
    - `accountID` - bank account number to check balance

  Read more about parameters' descripition here: https://developer.jengaapi.io/reference#get-account-balance

  ## Example
      iex> ExPesa.Jenga.AccountServices.AccountBalance.request(%{countryCode: "KE", accountID: "0011547896523"})
      {:ok,
        %{
            "currency" => "KES",
            "balances" => [
              %{
                "amount" => "997382.57",
                "type" => "Current"
              },
              %{
                "amount" => "997382.57",
                "type" => "Available"
              }
            ]
        }}

  """
  @spec request(map()) :: {:ok, any()} | {:error.any()}
  def request(%{countryCode: country_code, accountID: account_id}) do
    url = @uri_affix <> "#{country_code}/#{account_id}"
    message = "#{country_code}#{account_id}"
    headers = [{"signature", Signature.sign(message)}]

    get_request(url, headers)
  end

  def request(_),
    do: {:error, "Required Parameters missing, check your request body"}
end
