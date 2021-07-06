defmodule ExPesa.Jenga.JengaBase do
  @moduledoc false

  import ExPesa.Util
  alias ExPesa.TokenServer

  @live "https://jengahq.io"
  @sandbox "https://uat.jengahq.io"

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
    case Tesla.post(client, "/identity/v2/token", %{
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
    {:ok, body} = Jason.decode(body)
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

  def get_client(headers) do
    auth_client()
    |> token()
    |> case do
      {:ok, token} ->
        client = token |> client(headers)
        {:ok, client}

      {:error, message} ->
        {:error, message}

      _ ->
        {:error, 'An Error occurred, try again'}
    end
  end

  # ? headers will be used to pass the signatures in header
  def make_request(url, body, headers \\ []) do
    get_client(headers)
    |> case do
      {:ok, client} ->
        client
        |> Tesla.post(url, body, opts: [adapter: [recv_timeout: 30_000]])
        |> process_result

      {:error, message} ->
        {:error, message}
    end
  end

  @doc """
  performs `GET` requests.
  `get_request/2` accepts, parameters encoded url and headers
  `get_request/3` accepsts, url, body as map and headers
  """
  @spec get_request(bitstring(), keyword()) :: {:ok, map()} | {:error, bitstring()}
  def get_request(url, headers) when is_list(headers) do
    get_client(headers)
    |> case do
      {:ok, client} ->
        client
        |> Tesla.get(url, adapter: [recv_timeout: 30_000])
        |> process_result()

      {:error, message} ->
        {:error, message}
    end
  end

  @spec get_request(bitstring(), map(), keyword()) :: {:ok, map()} | {:error, bitstring()}

  def get_request(url, body, headers \\ []) do
    get_client(headers)
    |> case do
      {:ok, client} ->
        client
        |> Tesla.get(url, adapter: [recv_timeout: 30_000], body: body)
        |> process_result()

      {:error, message} ->
        {:error, message}
    end
  end

  @doc """
  Process results from calling the gateway
  """

  def process_result({:ok, %{status: 200} = res}) do
    if is_map(res.body) do
      if Map.has_key?(res.body, "response_status") && res.body["response_status"] === "error" do
        {:error, %{message: res.body}}
      else
        {:ok, res.body}
      end
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
