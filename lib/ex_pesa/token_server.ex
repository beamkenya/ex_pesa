defmodule ExPesa.TokenServer do
  @moduledoc false

  use GenServer
  @name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def insert(pid \\ @name, {type, token}), do: GenServer.cast(pid, {:insert, {type, token}})

  def get(pid \\ @name, type), do: GenServer.call(pid, {:get, type})

  @impl true
  def init(token_tuple) do
    {:ok, token_tuple}
  end

  @impl true
  def handle_cast({:insert, {type, token_tuple}}, state) do
    {:noreply, state |> Map.put(type, token_tuple)}
  end

  @impl true
  def handle_call({:get, type}, _from, state) do
    {:reply, Map.fetch(state, type), state}
  end
end
