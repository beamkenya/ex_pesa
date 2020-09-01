defmodule ExPesa.Mpesa.TokenServerTest do
  @moduledoc false

  use ExUnit.Case, async: true
  alias ExPesa.Mpesa.TokenServer

  #   setup do
  #     start_supervised!(TokenServer)
  #   end

  test "stores and retrieves token" do
    org_token = 'tsdgu66t327uygfe'
    TokenServer.insert({org_token, DateTime.add(DateTime.utc_now(), 3550, :second)})

    assert {token, datetime} = TokenServer.get()
    assert token === 'tsdgu66t327uygfe'
    assert DateTime.compare(datetime, DateTime.utc_now()) !== :g
  end
end
