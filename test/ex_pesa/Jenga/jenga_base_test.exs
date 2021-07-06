defmodule ExPesa.Jenga.JengaBaseTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock
  alias ExPesa.Jenga.JengaBase

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
        url: "https://uat.jengahq.io/accounts/v2/accounts/balances/KE/0011547896523",
        method: :get
      } ->
        %Tesla.Env{status: 200, body: %{}}

      %{
        url: "https://uat.jengahq.io/accounts/v2/accounts/balances/KE/0011547896523",
        method: :post
      } ->
        %Tesla.Env{status: 200, body: %{}}
    end)

    :ok
  end

  describe "Process Results" do
    test "response with result OK" do
      resp =
        {:ok,
         %{
           status: 400,
           body: %{
             responseCode: 0,
             success: true
           }
         }}

      JengaBase.process_result(resp)
    end

    test "response with result status 401 0n get token" do
      resp =
        {:ok,
         %{
           status: 401,
           body:
             Jason.encode!(%{
               responseCode: 0,
               success: true
             })
         }}

      JengaBase.get_token(resp)
    end

    test "response with result status 200 with error in body" do
      resp =
        {:ok,
         %{
           status: 200,
           body: %{
             "response_code" => "104101",
             "response_msg" => "Validation of account failed",
             "response_status" => "error"
           }
         }}

      JengaBase.process_result(resp)
    end
  end

  describe "Request" do
    test "get_request/2" do
      JengaBase.get_request(
        "https://uat.jengahq.io/accounts/v2/accounts/balances/KE/0011547896523",
        %{accountID: "2113131", countryCode: "KE"}
      )
    end

    test "get_request/3" do
      JengaBase.get_request(
        "https://uat.jengahq.io/accounts/v2/accounts/balances/KE/0011547896523",
        []
      )
    end
  end
end
