defmodule ExPesa.Jenga.SendMoneyQueries.AccountInquiryPesalinkBanks do
  @moduledoc """
  This webservice returns the recipients’ Linked Banks linked to the provided phone number on PesaLink
  """

  import ExPesa.Jenga.JengaBase

  @doc """
  Inquire about the recipients linked banks tied to a given phone number
    Read more about Pesalink participating banks here: https://developer.jengaapi.io/reference#account-inquiry-pesalink-banks

  ## Parameters

  attrs: - a map containing:
    - `mobileNumber` [string] - recipients mobile number eg 0763000000

  ## Example
      iex> ExPesa.Jenga.SendMoneyQueries.AccountInquiryPesalinkBanks.request(%{ mobileNumber: "0722000000"})
      {:ok,
        %{
          "banks" => [
            %{"bankCode" => "31", "bankName" => "Stanbic", "customerName" => "John Doe"}
          ]
        }
      }
  """
  @spec request(map()) :: {:error, any()} | {:ok, map()}
  def request(
        %{
          mobileNumber: _t
        } = requestBody
      ) do
    make_request("/transaction/v2/pesalink/inquire", requestBody)
  end

  def request(_) do
    {:error, "Required Parameters missing, check your request body"}
  end
end
