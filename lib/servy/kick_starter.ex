defmodule Servy.KickStarter do
  use GenServer

  # Client Interface

  def start do
    IO.puts "Starting the kickstarter..."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def start_link(_arg) do
    IO.puts "Starting the kickstarter..."
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    # Alternative: Process.whereis(:http_server)
    GenServer.call(__MODULE__, :get_server)
  end

  # Server Callbacks

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "HppsServer exited (#{inspect reason})"
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    IO.puts "Starting the HTTP server..."
    # server_pid = spawn(Servy.HttpServer, :start, [4000])
    # Process.link(server_pid)
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
