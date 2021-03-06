defmodule ExPesa.Jenga.KYC do
  @moduledoc """
  KYC enabales quering the various registrar of persons in the various countries in East Africa. 
  Visit https://developer.jengaapi.io/reference#identity-verification to see more details
  """
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @doc """
  Makes a request to retrieve KYC details for a given customer

  ## Example

      iex> ExPesa.Jenga.KYC.request(%{identity: %{documentType: "ALIENID", firstName: "John", lastName: "Doe", dateOfBirth: "1970-01-30",  documentNumber: "654321", countryCode: "KE"}})
      {:ok, %{"identity" => %{"customer" => %{"fullName" => "John Doe ", "firstName" => "John", "middlename" => "", "lastName" => "Doe", "ShortName" => "John", "birthDate" => "1900-01-01T00:00:00", "birthCityName" => "", "deathDate" => "", "gender" => "", "faceImage" => "/9j/4AAQSkZJRgABAAEAYABgA+H8qr6n4e1O71SGFbV/sEOF3O6/N/eb71d/FGkaBVXaq9KfRRRRRUMsKSIdyr0r/9k=", "occupation" => "", "nationality" => "Refugee"}, "documentType" => "ALIEN ID", "documentNumber" => "654321", "documentSerialNumber" => "100500425", "documentIssueDate" => "2002-11-29T12:00:00", "documentExpirationDate" => "2004-11-28T12:00:00", "IssuedBy" => "REPUBLIC OF KENYA", "additionalIdentityDetails" => [%{"documentNumber" => "", "documentType" => "", "issuedBy" => ""}], "address" => %{"provinceName" => " ", "districtName" => "", "locationName" => "", "subLocationName" => "", "villageName" => ""}}}}    
  """
  @spec request(%{
          identity: %{
            documentType: String.t(),
            firstName: String.t(),
            lastName: String.t(),
            dateOfBirth: String.t(),
            documentNumber: String.t(),
            countryCode: String.t()
          }
        }) :: {:error, any()} | {:ok, any()}
  def request(
        %{
          identity: %{
            documentType: _documentType,
            firstName: _firstName,
            lastName: _lastName,
            dateOfBirth: _dateOfBirth,
            documentNumber: documentNumber,
            countryCode: countryCode
          }
        } = requestBody
      ) do
    message = "#{merchant_code()}#{documentNumber}#{countryCode}"

    make_request("/customer/v2/identity/verify", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_), do: {:error, "Required Parameters missing, check your request body"}

  defp merchant_code do
    Application.get_env(:ex_pesa, :jenga)[:username]
  end
end
