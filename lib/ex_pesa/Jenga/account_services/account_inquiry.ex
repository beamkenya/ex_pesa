defmodule ExPesa.Jenga.AccountServices.AccountInquiry do
  @moduledoc """
  This enables your application to retrieve bank account details.
  """
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @uri_affix "/account/v2/search/"

  @doc """
  Get account details.
    - Currently restricted to banks in East and Central Africa ie
      Kenya, Uganda, Tanzania, Rwanda, Democratic Republic of Congo, South Sudan and Ethiopia.

    - This serves as the allowed country codes for quering account balances.
      Country code format information found here: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements

  ## Parameters
  A map with:-
    - `countryCode` - a string per above description
    - `accountID` - bank account number to get information about.

  More information here: https://developer.jengaapi.io/reference#account-inquiry
  """
  @spec request(map()) :: {:ok, any()} | {:error, any()}
  def request(%{countryCode: country_code, accountID: account_id}) do
    url = @uri_affix <> country_code <> "/" <> account_id
    message = country_code <> account_id
    headers = [{"signature", Signature.sign(message)}]

    get_request(url, headers)
  end

  def request(_),
    do: {:error, "Required parameters missing, check your request body and try again."}
end
