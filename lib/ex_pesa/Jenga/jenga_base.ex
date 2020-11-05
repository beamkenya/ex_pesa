defmodule ExPesa.Jenga.JengaBase do
  @moduledoc false

  import ExPesa.Util
  alias ExPesa.TokenServer

  @live "https://jengahq.io/identity/v2"
  @sandbox "https://sandbox.jengahq.io/identity-test/v2"

  def auth_client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, get_url(@live, @sandbox)},
      Tesla.Middleware.FormUrlencoded,
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Basic " <> Application.get_env(:ex_pesa, :jenga)[:api_key]},
         {"Content-Type", "application/x-www-form-urlencoded"}
       ]}
    ]

    Tesla.client(middleware)
  end

  def token(client) do
    case TokenServer.get(:jenga) do
      {:ok, {token, datetime}} ->
        if DateTime.compare(datetime, DateTime.utc_now()) !== :gt do
          generate_token(client)
        else
          {:ok, token}
        end

      :error ->
        generate_token(client)
    end
  end

  defp generate_token(client) do
    case Tesla.post(client, "/token", %{
           "username" => Application.get_env(:ex_pesa, :jenga)[:username],
           "password" => Application.get_env(:ex_pesa, :jenga)[:password]
         })
         |> get_token do
      {:ok, token} ->
        #  added 3550 secs, 50 less normal 3600 in 1 hr
        TokenServer.insert({:jenga, {token, DateTime.add(DateTime.utc_now(), 3550, :second)}})
        {:ok, token}

      {:error, message} ->
        {:error, message}
    end
  end

  @doc false
  def get_token({:ok, %{status: 401} = response}) do
    {:ok, body} = Jason.decode(response.body)
    {:error, body["message"]}
  end

  def get_token({:error, result}) do
    {:error, result}
  end

  @doc false
  def get_token({:ok, %{status: 200, body: body} = _response}) do
    {:ok, body["access_token"]}
  end

  def client(token, headers) do
    middleware = [
      {Tesla.Middleware.BaseUrl, get_url(@live, @sandbox)},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [{"Authorization", "Bearer " <> token}, {"Content-Type", "application/json"}] ++ headers}
    ]

    Tesla.client(middleware)
  end

  # ? headers will be used to pass the signatures in header
  def make_request(url, body, headers \\ []) do
    case token(auth_client()) do
      {:ok, token} ->
        Tesla.post(client(token, headers), url, body) |> process_result

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
