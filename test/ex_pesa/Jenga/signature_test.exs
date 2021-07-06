defmodule ExPesa.Jenga.SignatureTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExPesa.Jenga.Signature

  describe "verify signature" do
    raw_key = Application.get_env(:ex_pesa, :jenga)[:public_key]
    key = raw_key |> String.trim() |> String.split(~r{\n  *}, trim: true) |> Enum.join("\n")

    [pem_entry] = :public_key.pem_decode(key)

    public_key = :public_key.pem_entry_decode(pem_entry)

    message = "Hello"

    signature = Signature.sign(message) |> :base64.decode()

    Signature.sign_transaction(%{
      country_code: "country_code",
      account_id: "account_id"
    })

    assert true == :public_key.verify(message, :sha256, signature, public_key)
  end
end
