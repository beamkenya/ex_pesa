defmodule ExPesa.Mpesa.MpesaBase do
  @moduledoc false

  import ExPesa.Util

  @live "https://api.safaricom.co.ke"
  @sandbox "https://sandbox.safaricom.co.ke"

  def auth_client() do
    string =
      Application.get_env(:ex_pesa, :mpesa)[:consumer_key] <>
        ":" <> Application.get_env(:ex_pesa, :mpesa)[:consumer_secret]

    token = Base.encode64(string)

    middleware = [
      {Tesla.Middleware.BaseUrl, get_url(@live, @sandbox)},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [{"Authorization", "Basic " <> token}, {"Content-Type", "application/json"}]}
    ]

    Tesla.client(middleware)
  end

  def token(client) do
    Tesla.get(client, "/oauth/v1/generate?grant_type=client_credentials") |> get_token
  end

  @doc false
  def get_token({:ok, %{status: 400} = _response}) do
    {:error, "Wrong Credentials"}
  end

  def get_token({:error, result}) do
    {:error, result}
  end

  @doc false
  def get_token({:ok, %{status: 200, body: body} = _response}) do
    {:ok, body["access_token"]}
  end

  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, get_url(@live, @sandbox)},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [{"Authorization", "Bearer " <> token}, {"Content-Type", "application/json"}]}
    ]

    Tesla.client(middleware)
  end

  def make_request(url, body) do
    case token(auth_client()) do
      {:ok, token} ->
        Tesla.post(client(token), url, body) |> process_result

      {:error, message} ->
        {:error, message}

      _ ->
        {:error, 'An Error occurred, try again'}
    end
  end

  @doc """
  Process results from calling the gateway
  """

  def process_result({:ok, %{status: 200} = res}) do
    if is_map(res.body) do
      {:ok, res.body}
    else
      Jason.decode(res.body)
    end
  end

  def process_result({:ok, %{status: 201} = res}) do
    if is_map(res.body) do
      {:ok, res.body}
    else
      Jason.decode(res.body)
    end
  end

  def process_result({:ok, result}) do
    {:error, %{status: result.status, message: result.body}}
  end

  def process_result({:error, result}) do
    {:error, result}
  end
end
