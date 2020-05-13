defmodule Tcp do
  require Logger

  # 1. `:binary` - receives data as binaries (instead of lists)
  # 2. `packet: :line` - receives data line by line
  # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
  # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
  @opts [:binary, packet: :line, active: false, reuseaddr: true]

  @spec listen(char) :: port
  def listen(port) do
    {:ok, server_socket} = :gen_tcp.listen(port, @opts)

    Logger.info("Accepting connections on port #{port}")

    server_socket
  end

  @spec accept(port) :: port
  def accept(server_socket) do
    {:ok, client_socket} = :gen_tcp.accept(server_socket)

    Logger.info("New client connected")

    client_socket
  end

  @spec read_line(port) :: {:error, atom} | {:ok, any}
  def read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  @spec write_line(
          port,
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
        ) :: :ok | {:error, atom}
  def write_line(socket, line) do
    :gen_tcp.send(socket, line)
  end
end
