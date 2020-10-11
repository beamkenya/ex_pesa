defmodule ExPesa.Mpesa.MpesaBaseTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExPesa.Mpesa.MpesaBase

  describe "Process Results" do
    test "response with 201 status with map body" do
      resp =
        {:ok,
         %{
           status: 201,
           body: %{
             responseCode: 0,
             success: true
           }
         }}

      MpesaBase.process_result(resp)
    end

    test "response with 201 status with json body" do
      resp =
        {:ok,
         %{
           status: 201,
           body: """
           {
             "responseCode": 0,
             "success": true
           }
           """
         }}

      MpesaBase.process_result(resp)
    end

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

      MpesaBase.process_result(resp)
    end
  end
end
