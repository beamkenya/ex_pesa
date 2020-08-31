defmodule ExPesa.Mpesa.TokenServer do
  @moduledoc false

  use GenServer
  @name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    GenServer.start_link(__MODULE__, {'token', DateTime.utc_now()}, opts)
  end

  def insert(pid \\ @name, token), do: GenServer.cast(pid, {:insert, token})

  def get(pid \\ @name), do: GenServer.call(pid, :get)

  @impl true
  def init(token_tuple) do
    {:ok, token_tuple}
  end

  @impl true
  def handle_cast({:insert, token_tuple}, _state) do
    {:noreply, token_tuple}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
