defmodule Chat do
  @moduledoc """
  Telnet-based chat.
  """

  @doc """
  Starts a telnet-based chat server.
  """
  @spec start(any, [{:port, char}, ...]) :: no_return
  def start(_type, port: port) do
    Server.accept(port)
  end
end
