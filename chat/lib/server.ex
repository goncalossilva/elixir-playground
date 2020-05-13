defmodule Server do
  @moduledoc """
  Server component of the telnet-based chat.
  Handles incoming connections and message broadcasting.
  """

  require Tcp
  require Logger

  @spec accept(char) :: no_return
  def accept(port) do
    socket = Tcp.listen(port)
    pid = spawn_link(__MODULE__, :loop_broadcast, [self()])
    loop_acceptor(socket, pid)
  end

  @doc """
  Accepts connections and spawns Client processes to handle them.
  """
  @spec loop_acceptor(port, pid) :: no_return
  def loop_acceptor(socket, pid) do
    client_socket = Tcp.accept(socket)
    spawn_link(Client, :init, [pid, client_socket])
    loop_acceptor(socket, pid)
  end

  @doc """
  Broadcasts incoming messages from Client instances.
  """
  @spec loop_broadcast(pid) :: no_return
  def loop_broadcast(pid) do
    receive do
      message ->
        {_, links} = Process.info(pid, :links)
        pids = Enum.filter(links, fn link -> is_pid(link) and link != self() end)

        Logger.debug("Sending #{inspect(message)} to #{inspect(pids)}")

        for pid <- pids do
          send(pid, message)
        end

        loop_broadcast(pid)
    end
  end
end
