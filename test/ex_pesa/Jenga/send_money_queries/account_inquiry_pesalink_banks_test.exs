defmodule ExPesa.Jenga.SendMoneyQueries.AccountInquiryPesalinkBanksTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import Tesla.Mock

  alias ExPesa.Jenga.SendMoneyQueries.AccountInquiryPesalinkBanks

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

      %{url: "https://uat.jengahq.io/transaction/v2/pesalink/inquire", method: :post} ->
        %Tesla.Env{
          status: 200,
          body: %{
            "banks" => [
              %{"bankCode" => "31", "bankName" => "Stanbic", "customerName" => "John Doe"}
            ]
          }
        }
    end)

    :ok
  end

  describe "Account Inquiry - Pesalink Banks" do
    test "request/1 inquire about linked account" do
      request_body = %{mobileNumber: "0722000000"}

      {:ok, result} = AccountInquiryPesalinkBanks.request(request_body)

      assert result["banks"] == [
               %{"bankCode" => "31", "bankName" => "Stanbic", "customerName" => "John Doe"}
             ]
    end

    test "request/1 fail with no parameters passed" do
      {:error, message} = AccountInquiryPesalinkBanks.request("request_details")

      assert message == "Required Parameters missing, check your request body"
    end
  end
end
