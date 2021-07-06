defmodule ExPesa.Jenga.KYCTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Jenga.KYC

  alias ExPesa.Jenga.KYC

  setup do
    mock(fn
      %{
        url: "https://uat.jengahq.io/identity/v2/token",
        method: :post
      } ->
        %Tesla.Env{
          status: 200,
          body: """
          {
            "access_token" : "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm",
            "expires_in" : "3599"
          }
          """
        }

      %{url: "https://uat.jengahq.io/customer/v2/identity/verify", method: :post} ->
        %Tesla.Env{
          status: 200,
          body: %{
            "identity" => %{
              "customer" => %{
                "fullName" => "John Doe ",
                "firstName" => "John",
                "middlename" => "",
                "lastName" => "Doe",
                "ShortName" => "John",
                "birthDate" => "1900-01-01T00:00:00",
                "birthCityName" => "",
                "deathDate" => "",
                "gender" => "",
                "faceImage" =>
                  "/9j/4AAQSkZJRgABAAEAYABgA+H8qr6n4e1O71SGFbV/sEOF3O6/N/eb71d/FGkaBVXaq9KfRRRRRUMsKSIdyr0r/9k=",
                "occupation" => "",
                "nationality" => "Refugee"
              },
              "documentType" => "ALIEN ID",
              "documentNumber" => "654321",
              "documentSerialNumber" => "100500425",
              "documentIssueDate" => "2002-11-29T12:00:00",
              "documentExpirationDate" => "2004-11-28T12:00:00",
              "IssuedBy" => "REPUBLIC OF KENYA",
              "additionalIdentityDetails" => [
                %{
                  "documentNumber" => "",
                  "documentType" => "",
                  "issuedBy" => ""
                }
              ],
              "address" => %{
                "provinceName" => " ",
                "districtName" => "",
                "locationName" => "",
                "subLocationName" => "",
                "villageName" => ""
              }
            }
          }
        }
    end)

    :ok
  end

  describe "Query the various registrar of persons in the various countries in East Africa" do
    test "request/1 with correct params  successfully receives the customer details" do
      request_body = %{
        identity: %{
          documentType: "ALIENID",
          firstName: "John",
          lastName: "Doe",
          dateOfBirth: "1970-01-30",
          documentNumber: "654321",
          countryCode: "KE"
        }
      }

      assert {:ok, result} = KYC.request(request_body)

      assert result["identity"]["documentNumber"] == request_body.identity.documentNumber
    end

    test "request/1 fails when invalid params are passed" do
      assert {:error, message} = KYC.request("invalid params")

      assert message == "Required Parameters missing, check your request body"
    end
  end
end
