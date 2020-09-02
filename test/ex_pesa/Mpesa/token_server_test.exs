defmodule ExPesa.Mpesa.TokenServerTest do
  @moduledoc false

  import Tesla.Mock
  use ExUnit.Case, async: true
  alias ExPesa.Mpesa.TokenServer
  alias ExPesa.Mpesa.MpesaBase

  #   setup do
  #     start_supervised!(TokenServer)
  #   end

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
    end)

    :ok
  end

  test "stores and retrieves token" do
    org_token = "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm"
    TokenServer.insert({org_token, DateTime.add(DateTime.utc_now(), 3550, :second)})

    assert {token, datetime} = TokenServer.get()
    assert token === org_token
    assert DateTime.compare(datetime, DateTime.utc_now()) === :gt
  end

  test "new token generated when expired" do
    org_token = "SGWcJPtNtYNPGm6uSYR9yPYrAI"
    TokenServer.insert({org_token, DateTime.add(DateTime.utc_now(), -60, :second)})
    {_token, datetime} = TokenServer.get()
    assert DateTime.compare(datetime, DateTime.utc_now()) !== :gt

    MpesaBase.token(MpesaBase.auth_client())

    {token, datetime} = TokenServer.get()
    assert token !== org_token
    assert DateTime.compare(datetime, DateTime.utc_now()) === :gt
  end
end
