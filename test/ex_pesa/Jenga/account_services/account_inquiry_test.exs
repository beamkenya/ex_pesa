defmodule ExPesa.Jenga.AccountServices.AccountInquiryTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  doctest ExPesa.Jenga.AccountServices.AccountInquiry

  alias ExPesa.Jenga.AccountServices.AccountInquiry

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

      %{
        url: "https://uat.jengahq.io/account/v2/search/KE/0011547896523",
        method: :get
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
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
          }
        }
    end)

    :ok
  end

  describe "Account Info inquiry" do
    test "request/1 queries for the account balance" do
      request_body = %{countryCode: "KE", accountID: "0011547896523"}

      assert {:ok, response} = AccountInquiry.request(request_body)
      assert response["currency"] == "KES"
    end

    test "request/1 fail with no params" do
      {:error, message} = AccountInquiry.request(%{})
      assert message == "Required parameters missing, check your request body and try again."
    end
  end
end
