defmodule ExPesa.Mpesa.TokenServerTest do
  @moduledoc false

  import Tesla.Mock
  use ExUnit.Case, async: true
  alias ExPesa.TokenServer
  alias ExPesa.Mpesa.MpesaBase
  alias ExPesa.Jenga.JengaBase

  setup do
    mock(fn
      %{
        url: "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
        method: :get
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "access_token" => "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm",
            "expires_in" => "3599"
          }
        }

      %{
        url: "https://uat.jengahq.io/identity/v2/token",
        method: :post
      } ->
        %Tesla.Env{
          status: 200,
          body:
            "\n            {\n                \"token_type\": \"bearer\",\n                \"issued_at\": \"1604754920874\",\n                \"expires_in\": \"3599\",\n                \"access_token\": \"AuPMdNYCJoaPX8seRXAMAXcM1r1e\"\n            }\n        "
        }
    end)

    :ok
  end

  test "starts OTP server" do
    TokenServer.start_link()
  end

  test "stores and retrieves token" do
    org_token = "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm"
    TokenServer.insert({:mpesa, {org_token, DateTime.add(DateTime.utc_now(), 3550, :second)}})

    assert {:ok, {token, datetime}} = TokenServer.get(:mpesa)
    assert token === org_token
    assert DateTime.compare(datetime, DateTime.utc_now()) === :gt
  end

  test "new token generated when expired mpesa" do
    org_token = "SGWcJPtNtYNPGm6uSYR9yPYrAI"
    TokenServer.insert({:mpesa, {org_token, DateTime.add(DateTime.utc_now(), -60, :second)}})
    {:ok, {_token, datetime}} = TokenServer.get(:mpesa)
    assert DateTime.compare(datetime, DateTime.utc_now()) !== :gt

    MpesaBase.token(MpesaBase.auth_client())

    {:ok, {token, datetime}} = TokenServer.get(:mpesa)
    assert token !== org_token
    assert DateTime.compare(datetime, DateTime.utc_now()) === :gt
  end

  test "new token generated at init, :jenga" do
    JengaBase.token(JengaBase.auth_client())

    {:ok, {_token, datetime}} = TokenServer.get(:jenga)
    assert DateTime.compare(datetime, DateTime.utc_now()) === :gt
  end

  test "new token reused when fresh, :jenga" do
    org_token = "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm"
    TokenServer.insert({:jenga, {org_token, DateTime.add(DateTime.utc_now(), 3550, :second)}})

    JengaBase.token(JengaBase.auth_client())

    {:ok, {token, datetime}} = TokenServer.get(:jenga)
    assert token === org_token
    assert DateTime.compare(datetime, DateTime.utc_now()) === :gt
  end

  test "new token generated when expired, :jenga" do
    org_token = "SGWcJPtNtYNPGm6uSYR9yPYrAI"
    TokenServer.insert({:jenga, {org_token, DateTime.add(DateTime.utc_now(), -60, :second)}})
    {:ok, {_token, datetime}} = TokenServer.get(:jenga)
    assert DateTime.compare(datetime, DateTime.utc_now()) !== :gt

    JengaBase.token(JengaBase.auth_client())

    {:ok, {token, datetime}} = TokenServer.get(:jenga)
    assert token !== org_token
    assert DateTime.compare(datetime, DateTime.utc_now()) === :gt
  end
end
