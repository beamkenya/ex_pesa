defmodule ExPesa.Jenga.JengaBaseTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExPesa.Jenga.JengaBase

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
end
