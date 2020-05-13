defmodule Client do
  @moduledoc """
  Client component of the telnet-based chat.
  Handles reading from the telnet connection, passing to Server for
  broadcasting, and writing broadcasted messages to the telnet connection.
  """

  require Tcp
  require IO.ANSI
  require Logger

  @spec init(pid, port) :: no_return
  def init(server_pid, socket) do
    Tcp.write_line(socket, "Nickname: ")
    {:ok, nickname} = Tcp.read_line(socket)
    nickname = String.trim(nickname)
    send(server_pid, {:join, nickname})

    write_message(socket, nickname)

    spawn_link(__MODULE__, :loop_write, [socket, server_pid, nickname])
    loop_read(socket, nickname)
  end

  @doc """
  Receives broadcasts and prints them.
  """
  @spec loop_read(port, String.t()) :: no_return
  def loop_read(socket, nickname) do
    Logger.debug("Client reading on #{inspect(self())}")

    receive do
      {:join, who} when who != nickname ->
        write_message(socket, nickname, "#{who} joined the chat")
        loop_read(socket, nickname)

      {:message, {who, message}} when who != nickname ->
        write_message(socket, nickname, "#{who}: #{message}")
        loop_read(socket, nickname)

      {:leave, who} when who != nickname ->
        write_message(socket, nickname, "#{who} left the chat")
        loop_read(socket, nickname)

      _ ->
        loop_read(socket, nickname)
    end
  end

  @doc """
  Reads input coming from telnet and passes it to Server for Broadcasting.
  """
  @spec loop_write(port, pid, String.t()) :: no_return
  def loop_write(socket, server_pid, nickname) do
    case Tcp.read_line(socket) do
      {:ok, message} ->
        send(server_pid, {:message, {nickname, message}})
        write_message(socket, nickname, "#{IO.ANSI.cursor_up()}")
        loop_write(socket, server_pid, nickname)

      {:error, _} ->
        send(server_pid, {:leave, nickname})
    end
  end

  @spec write_message(port, String.t(), String.t()) :: no_return
  defp write_message(socket, nickname, message \\ "") do
    Tcp.write_line(socket, "\r#{String.trim(message)}\n#{nickname}: ")
  end
end
