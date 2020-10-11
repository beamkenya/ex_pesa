defmodule ExPesa.UtilsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExPesa.Util

  describe "generates secutityCredential" do
    result = Util.get_security_credential_for(:b2b)
    assert is_bitstring(result)
  end
end
