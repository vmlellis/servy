defmodule Servy.PledgeServerHandRolled do

  @name :pledge_server_hand_rolled

  alias Servy.GenericServer

  # Client interface

  def start(initial_state \\ []) do
    IO.puts "Starting the pledge server..."
    GenericServer.start(__MODULE__, initial_state, @name)
  end

  def create_pledge(name, amount) do
    GenericServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenericServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenericServer.call @name, :total_pledged
  end

  def clear do
    GenericServer.cast @name, :clear
  end

  # Server Callbacks

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = state |> Enum.take(2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call(:total_pledged, state) do
    total = state |> Enum.map(&elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_cast(:clear, _state) do
    []
  end

  def handle_info(other, state) do
    IO.puts "Unexpected message: #{inspect other}"
    state
  end

  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServerHandRolled

# pid = PledgeServerHandRolled.start

# send pid, {:stop, "hammertime"}

# IO.inspect PledgeServerHandRolled.create_pledge("larry", 10)
# IO.inspect PledgeServerHandRolled.create_pledge("moe", 20)
# IO.inspect PledgeServerHandRolled.create_pledge("curly", 30)
# IO.inspect PledgeServerHandRolled.create_pledge("daisy", 40)

# PledgeServerHandRolled.clear()

# IO.inspect PledgeServerHandRolled.create_pledge("grace", 50)

# IO.inspect PledgeServerHandRolled.recent_pledges()

# IO.inspect PledgeServerHandRolled.total_pledged()

# IO.inspect Process.info(pid, :messages)
